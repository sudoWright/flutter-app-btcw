import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet/helper/exceptions.dart';
import 'package:wallet/helper/extension/data.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/helper/walletkey_helper.dart';
import 'package:wallet/managers/features/proton.recovery/proton.recovery.state.dart';
import 'package:wallet/managers/providers/user.data.provider.dart';
import 'package:wallet/managers/users/user.manager.dart';
import 'package:wallet/rust/api/api_service/proton_settings_client.dart';
import 'package:wallet/rust/api/api_service/proton_users_client.dart';
import 'package:proton_crypto/proton_crypto.dart' as proton_crypto;
import 'package:wallet/rust/api/bdk_wallet/mnemonic.dart';
import 'package:wallet/rust/api/srp/srp_client.dart';
import 'package:wallet/rust/common/errors.dart';
import 'package:wallet/rust/proton_api/proton_users.dart';
import 'package:wallet/rust/srp/proofs.dart';

// Define the events
abstract class ProtonRecoveryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingRecovery extends ProtonRecoveryEvent {}

class TestRecovery extends ProtonRecoveryEvent {}

class EnableRecovery extends ProtonRecoveryEvent {
  final RecoverySteps step;
  final String password;
  final String twofa;

  EnableRecovery(
    this.step, {
    this.password = "",
    this.twofa = "",
  });
  @override
  List<Object> get props => [step];
}

class DisableRecovery extends ProtonRecoveryEvent {
  final RecoverySteps step;
  final String password;
  final String twofa;

  DisableRecovery(
    this.step, {
    this.password = "",
    this.twofa = "",
  });
  @override
  List<Object> get props => [step];
}

/// Define the Bloc
class ProtonRecoveryBloc
    extends Bloc<ProtonRecoveryEvent, ProtonRecoveryState> {
  final UserManager userManager;
  final ProtonUsersClient protonUsersApi;
  final ProtonSettingsClient protonSettingsApi;
  final UserDataProvider userDataProvider;

  /// initialize the bloc with the initial state
  ProtonRecoveryBloc(
    this.userManager,
    this.protonUsersApi,
    this.userDataProvider,
    this.protonSettingsApi,
  ) : super(const ProtonRecoveryState()) {
    on<LoadingRecovery>((event, emit) async {
      emit(state.copyWith(
          isLoading: true,
          error: "",
          isRecoveryEnabled: false,
          mnemonic: "",
          authInfo: null,
          requireAuthModel: const RequireAuthModel()));

      var userInfo = await protonUsersApi.getUserInfo();
      var status = userInfo.mnemonicStatus == 3;

      emit(state.copyWith(isLoading: false, isRecoveryEnabled: status));
    });

    on<TestRecovery>((event, emit) async {
      emit(state.copyWith(
          isLoading: true,
          error: "",
          isRecoveryEnabled: false,
          mnemonic:
              "banner tag desk cart mirror horse name minimum hen sport sadness evidence",
          authInfo: null,
          requireAuthModel: const RequireAuthModel()));

      var userInfo = await protonUsersApi.getUserInfo();
      var status = userInfo.mnemonicStatus == 3;

      emit(state.copyWith(isLoading: false, isRecoveryEnabled: status));
    });

    on<EnableRecovery>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: ""));
      // get user info
      var userInfo = await protonUsersApi.getUserInfo();
      var status = userInfo.mnemonicStatus;
      // 0 - Mnemonic is disabled
      // 1 - Mnemonic is enabled but not set
      // 2 - Mnemonic is enabled but needs to be re-activated
      // 3 - Mnemonic is enabled and set
      if (status == 0 || status == 1) {
        /// set new flow
        /// get auth info

        if (event.step == RecoverySteps.start) {
          // var status = userInfo.mnemonicStatus;
          // check if the status is disabled already skip the process
          /// get auth info
          var authInfo = await protonUsersApi.getAuthInfo(intent: "Proton");

          /// 0 for disabled, 1 for OTP, 2 for FIDO2, 3 for both
          var twoFaEnable = authInfo.twoFa.enabled;
          var authSetp = RequireAuthModel(
              requireAuth: true, twofaStatus: twoFaEnable, isDisable: false);
          emit(state.copyWith(requireAuthModel: authSetp, authInfo: authInfo));
        } else if (event.step == RecoverySteps.auth) {
          var loginPassword = event.password;
          var loginTwoFa = event.twofa;
          var authInfo = state.authInfo ??
              await protonUsersApi.getAuthInfo(intent: "Proton");

          /// build srp client proof
          var clientProofs = await SrpClient.generateProofs(
              loginPassword: loginPassword,
              version: authInfo.version,
              salt: authInfo.salt,
              modulus: authInfo.modulus,
              serverEphemeral: authInfo.serverEphemeral);

          /// password scop unlock password change  ---  add 2fa code if needed
          var proofs = authInfo.twoFa.enabled == 1
              ? ProtonSrpClientProofs(
                  clientEphemeral: clientProofs.clientEphemeral,
                  clientProof: clientProofs.clientProof,
                  srpSession: authInfo.srpSession,
                  twoFactorCode: loginTwoFa)
              : ProtonSrpClientProofs(
                  clientEphemeral: clientProofs.clientEphemeral,
                  clientProof: clientProofs.clientProof,
                  srpSession: authInfo.srpSession);

          var serverProofs =
              await protonUsersApi.unlockPasswordChange(proofs: proofs);

          /// check if the server proofs are valid
          var check = clientProofs.expectedServerProof == serverProofs;
          logger.i("EnableRecovery password server proofs: $check");
          if (!check) {
            return Future.error('Invalid server proofs');
          }

          /// generate new entropy and mnemonic
          var salt = WalletKeyHelper.getRandomValues(16);
          var randomEntropy = WalletKeyHelper.getRandomValues(16);

          FrbMnemonic mnemonic = FrbMnemonic.newWith(entropy: randomEntropy);
          var mnemonicWords = mnemonic.asWords();
          logger.d("Recovery Mnemonic: $mnemonicWords");
          var recoveryPassword = randomEntropy.base64encode();

          var hashedPassword = await SrpClient.computeKeyPassword(
            password: recoveryPassword,
            salt: salt,
          );

          var userFirstKey = await userManager.getFirstKey();
          var userKeys = userInfo.keys;
          if (userKeys == null) {
            return Future.error('User keys not found');
          }
          if (userKeys.length != 1) {
            return Future.error('More then one key is not supported yet');
          }

          var oldPassphrase = userFirstKey.passphrase;

          List<MnemonicUserKey> mnUserKeys = [];

          /// reencrypt password for now only support one
          for (ProtonUserKey key in userKeys) {
            var newKey = proton_crypto.changePrivateKeyPassword(
              key.privateKey,
              oldPassphrase,
              hashedPassword,
            );
            mnUserKeys.add(MnemonicUserKey(id: key.id, privateKey: newKey));
          }

          /// get srp module
          var serverModule = await protonUsersApi.getAuthModule();

          /// get clear text and verify signature
          SRPVerifierB64 verifier = await SrpClient.generateVerifer(
            password: recoveryPassword,
            serverModulus: serverModule.modulus,
          );

          var auth = MnemonicAuth(
            modulusId: serverModule.modulusId,
            salt: verifier.salt,
            version: verifier.version,
            verifier: verifier.verifier,
          );

          var req = UpdateMnemonicSettingsRequestBody(
            mnemonicUserKeys: mnUserKeys,
            mnemonicSalt: salt.base64encode(),
            mnemonicAuth: auth,
          );

          try {
            var code = await protonSettingsApi.setMnemonicSettings(req: req);
            logger.i("EnableRecovery response code: $code");
            code = await protonUsersApi.lockSensitiveSettings();
            logger.i("EnableRecovery lockSensitiveSettings: $code");
            if (code != 1000) {
              emit(state.copyWith(
                isLoading: false,
                requireAuthModel: const RequireAuthModel(),
                authInfo: null,
                error: "Eanble recovery failed, please try again. code: $code",
              ));
              return;
            }
            emit(state.copyWith(
                isLoading: false,
                error: "",
                isRecoveryEnabled: true,
                requireAuthModel: const RequireAuthModel(),
                mnemonic: mnemonicWords.join(" "),
                authInfo: null));
          } on BridgeError catch (e) {
            var errorMessage = parseSampleDisplayError(e);
            emit(state.copyWith(
                isLoading: false,
                requireAuthModel: const RequireAuthModel(),
                authInfo: null,
                error: errorMessage));
          } catch (e) {
            emit(state.copyWith(
                isLoading: false,
                requireAuthModel: const RequireAuthModel(),
                authInfo: null,
                error: e.toString()));
          }
        }

        /// set mnemonic
      } else if (status == 2 || status == 4) {
        /// reactive flow
        /// generate new entropy and mnemonic
        var salt = WalletKeyHelper.getRandomValues(16);
        var randomEntropy = WalletKeyHelper.getRandomValues(16);

        FrbMnemonic mnemonic = FrbMnemonic.newWith(entropy: randomEntropy);
        var mnemonicWords = mnemonic.asWords();
        logger.d("Recovery Mnemonic: $mnemonicWords");
        var recoveryPassword = randomEntropy.base64encode();

        var hashedPassword = await SrpClient.computeKeyPassword(
          password: recoveryPassword,
          salt: salt,
        );

        var userFirstKey = await userManager.getFirstKey();
        var userKeys = userInfo.keys;
        if (userKeys == null) {
          return Future.error('User keys not found');
        }
        if (userKeys.length != 1) {
          return Future.error('More then one key is not supported yet');
        }

        var oldPassphrase = userFirstKey.passphrase;

        List<MnemonicUserKey> mnUserKeys = [];

        /// reencrypt password for now only support one
        for (ProtonUserKey key in userKeys) {
          var newKey = proton_crypto.changePrivateKeyPassword(
            key.privateKey,
            oldPassphrase,
            hashedPassword,
          );
          mnUserKeys.add(MnemonicUserKey(id: key.id, privateKey: newKey));
        }

        /// get srp module
        var serverModule = await protonUsersApi.getAuthModule();

        /// get clear text and verify signature
        SRPVerifierB64 verifier = await SrpClient.generateVerifer(
          password: recoveryPassword,
          serverModulus: serverModule.modulus,
        );

        var auth = MnemonicAuth(
          modulusId: serverModule.modulusId,
          salt: verifier.salt,
          version: verifier.version,
          verifier: verifier.verifier,
        );

        var req = UpdateMnemonicSettingsRequestBody(
          mnemonicUserKeys: mnUserKeys,
          mnemonicSalt: salt.base64encode(),
          mnemonicAuth: auth,
        );

        try {
          var code = await protonSettingsApi.reactiveMnemonicSettings(req: req);
          logger.i("EnableRecovery response code: $code");
          if (code != 1000) {
            emit(state.copyWith(
              isLoading: false,
              requireAuthModel: const RequireAuthModel(),
              authInfo: null,
              error: "Eanble recovery failed, please try again. code: $code",
            ));
            return;
          }
          emit(state.copyWith(
              isLoading: false,
              error: "",
              isRecoveryEnabled: true,
              requireAuthModel: const RequireAuthModel(),
              mnemonic: mnemonicWords.join(" "),
              authInfo: null));
        } on BridgeError catch (e) {
          var errorMessage = parseSampleDisplayError(e);
          emit(state.copyWith(
              isLoading: false,
              requireAuthModel: const RequireAuthModel(),
              authInfo: null,
              error: errorMessage));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false,
              requireAuthModel: const RequireAuthModel(),
              authInfo: null,
              error: e.toString()));
        }
      }

      /// build random srp verifier.
    });

    on<DisableRecovery>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: ""));

      if (event.step == RecoverySteps.start) {
        // var status = userInfo.mnemonicStatus;
        // check if the status is disabled already skip the process
        /// get auth info
        var authInfo = await protonUsersApi.getAuthInfo(intent: "Proton");

        /// 0 for disabled, 1 for OTP, 2 for FIDO2, 3 for both
        var twoFaEnable = authInfo.twoFa.enabled;
        var authSetp = RequireAuthModel(
            requireAuth: true, twofaStatus: twoFaEnable, isDisable: true);
        emit(state.copyWith(requireAuthModel: authSetp, authInfo: authInfo));
      } else if (event.step == RecoverySteps.auth) {
        var loginPassword = event.password;
        var loginTwoFa = event.twofa;
        var authInfo = state.authInfo ??
            await protonUsersApi.getAuthInfo(intent: "Proton");

        /// build srp client proof
        var clientProofs = await SrpClient.generateProofs(
            loginPassword: loginPassword,
            version: authInfo.version,
            salt: authInfo.salt,
            modulus: authInfo.modulus,
            serverEphemeral: authInfo.serverEphemeral);

        var proofs = authInfo.twoFa.enabled == 1
            ? ProtonSrpClientProofs(
                clientEphemeral: clientProofs.clientEphemeral,
                clientProof: clientProofs.clientProof,
                srpSession: authInfo.srpSession,
                twoFactorCode: loginTwoFa)
            : ProtonSrpClientProofs(
                clientEphemeral: clientProofs.clientEphemeral,
                clientProof: clientProofs.clientProof,
                srpSession: authInfo.srpSession);

        try {
          /// build request
          var serverProofs = await protonSettingsApi.disableMnemonicSettings(
            proofs: proofs,
          );

          /// check if the server proofs are valid
          var check = clientProofs.expectedServerProof == serverProofs;
          logger.i("DisableRecovery server proofs: $check");

          emit(state.copyWith(
              isLoading: false,
              isRecoveryEnabled: false,
              requireAuthModel: const RequireAuthModel(),
              authInfo: null));
        } on BridgeError catch (e) {
          var errorMessage = parseSampleDisplayError(e);
          emit(state.copyWith(
              isLoading: false,
              requireAuthModel: const RequireAuthModel(),
              authInfo: null,
              error: errorMessage));
        } catch (e) {
          emit(state.copyWith(
              isLoading: false,
              requireAuthModel: const RequireAuthModel(),
              authInfo: null,
              error: e.toString()));
        }
      } else {}
    });
  }

  Future<void> enableRecovery() async {}

  Future<void> disableRecovery() async {}
}
