import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/helper/exchange.caculator.dart';
import 'package:wallet/managers/services/exchange.rate.service.dart';
import 'package:wallet/helper/extension/enum.extension.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/helper/walletkey_helper.dart';
import 'package:wallet/managers/features/models/wallet.list.dart';
import 'package:wallet/managers/providers/user.settings.data.provider.dart';
import 'package:wallet/managers/providers/wallet.data.provider.dart';
import 'package:wallet/managers/providers/wallet.keys.provider.dart';
import 'package:wallet/managers/providers/wallet.passphrase.provider.dart';
import 'package:wallet/managers/users/user.manager.dart';
import 'package:wallet/managers/wallet/wallet.manager.dart';
import 'package:wallet/models/account.model.dart';
import 'package:wallet/models/drift/db/app.database.dart';
import 'package:wallet/models/wallet.model.dart';
import 'package:proton_crypto/proton_crypto.dart' as proton_crypto;
import 'package:wallet/rust/proton_api/exchange_rate.dart';
import 'package:wallet/rust/proton_api/user_settings.dart';

// Define the events
abstract class WalletListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SelectWallet extends WalletListEvent {
  final WalletModel walletModel;

  SelectWallet(this.walletModel);

  @override
  List<Object> get props => [walletModel];
}

class UpdateWalletName extends WalletListEvent {
  final WalletModel walletModel;
  final String newName;

  UpdateWalletName(this.walletModel, this.newName);

  @override
  List<Object> get props => [walletModel, newName];
}

class StartLoading extends WalletListEvent {
  final VoidCallback? callback;

  StartLoading({this.callback});

  @override
  List<Object> get props => [];
}

class SelectAccount extends WalletListEvent {
  final WalletModel walletModel;
  final AccountModel accountModel;

  SelectAccount(this.walletModel, this.accountModel);

  @override
  List<Object> get props => [walletModel, accountModel];
}

class UpdateAccountName extends WalletListEvent {
  final WalletModel walletModel;
  final AccountModel accountModel;
  final String newName;

  UpdateAccountName(this.walletModel, this.accountModel, this.newName);

  @override
  List<Object> get props => [walletModel, accountModel, newName];
}

class AddEmailIntegration extends WalletListEvent {
  final WalletModel walletModel;
  final AccountModel accountModel;
  final String emailID;

  AddEmailIntegration(this.walletModel, this.accountModel, this.emailID);

  @override
  List<Object> get props => [walletModel, accountModel, emailID];
}

class RemoveEmailIntegration extends WalletListEvent {
  final WalletModel walletModel;
  final AccountModel accountModel;
  final String emailID;

  RemoveEmailIntegration(this.walletModel, this.accountModel, this.emailID);

  @override
  List<Object> get props => [walletModel, accountModel, emailID];
}

class UpdateAccountFiat extends WalletListEvent {
  final WalletModel walletModel;
  final AccountModel accountModel;
  final String fiatName;

  UpdateAccountFiat(this.walletModel, this.accountModel, this.fiatName);

  @override
  List<Object> get props => [walletModel, accountModel, fiatName];
}

// Define the state
class WalletListState extends Equatable {
  final bool initialized;
  final List<WalletMenuModel> walletsModel;

  const WalletListState({
    required this.initialized,
    required this.walletsModel,
  });

  @override
  List<Object?> get props => [initialized, walletsModel];
}

extension WalletListStateCopyWith on WalletListState {
  WalletListState copyWith({
    bool? initialized,
    List<WalletMenuModel>? walletsModel,
  }) {
    return WalletListState(
      initialized: initialized ?? this.initialized,
      walletsModel: walletsModel ?? this.walletsModel,
    );
  }
}

/// Define the Bloc
class WalletListBloc extends Bloc<WalletListEvent, WalletListState> {
  final WalletsDataProvider walletsDataProvider;
  final WalletPassphraseProvider walletPassProvider;
  final WalletKeysProvider walletKeysProvider;
  final UserSettingsDataProvider userSettingsDataProvider;
  final UserManager userManager;

  WalletListBloc(
    this.walletsDataProvider,
    this.walletPassProvider,
    this.walletKeysProvider,
    this.userManager,
    this.userSettingsDataProvider,
  ) : super(const WalletListState(initialized: false, walletsModel: [])) {
    walletsDataProvider.dataUpdateController.stream.listen((onData) {
      add(StartLoading());
    });
    on<StartLoading>((event, emit) async {
      // loading wallet data
      logger.i("StartLoading!!!!!");
      var wallets = await walletsDataProvider.getWallets();
      if (wallets == null) {
        emit(state.copyWith(initialized: true, walletsModel: []));
        return; // error;
      }

      /// get user key
      var userkey = await userManager.getFirstKey();
      var userPrivateKey = userkey.privateKey;
      var userPassphrase = userkey.passphrase;

      List<WalletMenuModel> walletsModel = [];
      int index = 0;
      for (WalletData wallet in wallets) {
        WalletMenuModel walletModel = WalletMenuModel(wallet.wallet);
        if (index == 0 && walletsDataProvider.selectedServerWalletID.isEmpty) {
          walletModel.isSelected = true;
        } else {
          if (walletModel.walletModel.serverWalletID ==
              walletsDataProvider.selectedServerWalletID) {
            walletModel.isSelected = true;
          }
        }
        walletModel.currentIndex = index++;

        // check if wallet has password valid. no password is valid
        walletModel.hasValidPassword = await _hasValidPassphrase(
          wallet.wallet,
          walletPassProvider,
        );
        var walletKey = await walletKeysProvider.getWalletKey(
          wallet.wallet.serverWalletID,
        );
        Uint8List? entropy;
        SecretKey? secretKey;
        if (walletKey != null) {
          var pgpEncryptedWalletKey = walletKey.walletKey;
          var signature = walletKey.walletKeySignature;
          // decrypt wallet key
          entropy = proton_crypto.decryptBinaryPGP(
            userPrivateKey,
            userPassphrase,
            pgpEncryptedWalletKey,
          );
          var userPublicKey = proton_crypto.getArmoredPublicKey(userPrivateKey);
          // check signature
          var isValidWalletKeySignature =
              proton_crypto.verifyBinarySignatureWithContext(
            userPublicKey,
            entropy,
            signature,
            gpgContextWalletKey,
          );
          walletModel.isSignatureValid = isValidWalletKeySignature;
          logger.i("isValidWalletKeySignature = $isValidWalletKeySignature");

          secretKey = WalletKeyHelper.restoreSecretKeyFromEntropy(entropy);
        }
        walletModel.accountSize = wallet.accounts.length;
        walletModel.walletName = wallet.wallet.name;

        if (secretKey != null) {
          try {
            walletModel.walletName = await WalletKeyHelper.decrypt(
              secretKey,
              wallet.wallet.name,
            );
          } catch (e) {
            logger.e(e.toString());
          }
        }

        for (AccountModel account in wallet.accounts) {
          AccountMenuModel accMenuModel = AccountMenuModel(account);

          if (walletModel.walletModel.serverWalletID ==
                  walletsDataProvider.selectedServerWalletID &&
              accMenuModel.accountModel.serverAccountID ==
                  walletsDataProvider.selectedServerWalletAccountID) {
            accMenuModel.isSelected = true;
          }

          if (secretKey != null) {
            var encrypted = base64Encode(account.label);
            try {
              accMenuModel.label = await WalletKeyHelper.decrypt(
                secretKey,
                encrypted,
              );
            } catch (e) {
              logger.e(e.toString());
            }
          }

          // TODO:: fixme
          var balance = await WalletManager.getWalletAccountBalance(
            wallet.wallet.id!,
            account.id!,
          );

          accMenuModel.balance = balance.toInt();
          double estimateValue = 0.0;
          var settings = await userSettingsDataProvider.getSettings();
          // Tempary need to use providers
          var fiatCurrency = WalletManager.getAccountFiatCurrency(account);
          ProtonExchangeRate? exchangeRate =
              await ExchangeRateService.getExchangeRate(fiatCurrency);
          estimateValue = ExchangeCalculator.getNotionalInFiatCurrency(
            exchangeRate,
            balance.toInt(),
          );
          var fiatName = fiatCurrency.name.toString().toUpperCase();
          accMenuModel.currencyBalance =
              "$fiatName ${estimateValue.toStringAsFixed(defaultDisplayDigits)}";
          accMenuModel.btcBalance = ExchangeCalculator.getBitcoinUnitLabel(
            (settings?.bitcoinUnit ?? "btc").toBitcoinUnit(),
            balance.toInt(),
          );

          accMenuModel.emailIds =
              await WalletManager.getAccountAddressIDs(account.serverAccountID);

          ///
          walletModel.accounts.add(accMenuModel);
        }

        ///
        walletsModel.add(walletModel);
      }

      ///
      emit(state.copyWith(initialized: true, walletsModel: walletsModel));
      if (event.callback != null) {
        event.callback!.call();
      }
      logger.i("StartLoading end!!!!!");
    });

    on<SelectWallet>((event, emit) async {
      for (WalletMenuModel walletModel in state.walletsModel) {
        walletModel.isSelected = walletModel.walletModel.serverWalletID ==
            event.walletModel.serverWalletID;
        if (walletModel.isSelected) {
          walletsDataProvider.selectedServerWalletID =
              event.walletModel.serverWalletID;
        }
        for (AccountMenuModel account in walletModel.accounts) {
          account.isSelected = false;
        }
      }
      emit(state.copyWith(walletsModel: state.walletsModel));
    });

    on<SelectAccount>((event, emit) async {
      for (WalletMenuModel walletModel in state.walletsModel) {
        walletModel.isSelected = false;
        if (walletModel.walletModel.serverWalletID ==
            event.walletModel.serverWalletID) {
          for (AccountMenuModel account in walletModel.accounts) {
            account.isSelected = account.accountModel.serverAccountID ==
                event.accountModel.serverAccountID;
            if (account.isSelected) {
              userSettingsDataProvider.updateFiatCurrency(
                  account.accountModel.fiatCurrency.toFiatCurrency());
              walletsDataProvider.selectedServerWalletID =
                  event.walletModel.serverWalletID;
              walletsDataProvider.selectedServerWalletAccountID =
                  event.accountModel.serverAccountID;
            }
          }
        } else {
          for (AccountMenuModel account in walletModel.accounts) {
            account.isSelected = false;
          }
        }
      }
      emit(state.copyWith(walletsModel: state.walletsModel));
    });

    on<UpdateWalletName>((event, emit) async {
      for (WalletMenuModel walletModel in state.walletsModel) {
        if (walletModel.walletModel.serverWalletID ==
            event.walletModel.serverWalletID) {
          walletModel.walletName = event.newName;

          /// TODO:: infomr data provider to update name? but this is WalletMenuModel only, data provider need walletMdoel
          break;
        }
      }
      emit(state.copyWith(walletsModel: state.walletsModel));
    });

    on<UpdateAccountFiat>((event, emit) async {
      for (WalletMenuModel walletModel in state.walletsModel) {
        if (walletModel.walletModel.serverWalletID ==
            event.walletModel.serverWalletID) {
          for (AccountMenuModel account in walletModel.accounts) {
            if (account.accountModel.serverAccountID ==
                event.accountModel.serverAccountID) {
              /// TODO:: handle wallet account view change here
              if (account.isSelected) {
                userSettingsDataProvider.updateFiatCurrency(event.fiatName.toFiatCurrency());
              }
              account.accountModel.fiatCurrency = event.fiatName;
              walletsDataProvider.updateWalletAccount(
                  accountModel: event.accountModel);

              double estimateValue = 0.0;
              var settings = await userSettingsDataProvider.getSettings();

              // TODO:: fixme
              var balance = await WalletManager.getWalletAccountBalance(
                walletModel.walletModel.id!,
                account.accountModel.id!,
              );
              // Tempary need to use providers
              var fiatCurrency =
                  WalletManager.getAccountFiatCurrency(account.accountModel);
              ProtonExchangeRate? exchangeRate =
                  await ExchangeRateService.getExchangeRate(fiatCurrency);
              estimateValue = ExchangeCalculator.getNotionalInFiatCurrency(
                exchangeRate,
                balance.toInt(),
              );

              account.currencyBalance =
                  "${event.fiatName} ${estimateValue.toStringAsFixed(defaultDisplayDigits)}";
              account.btcBalance = ExchangeCalculator.getBitcoinUnitLabel(
                (settings?.bitcoinUnit ?? "btc").toBitcoinUnit(),
                balance.toInt(),
              );
              break;
            }
          }
          break;
        }
      }
      emit(state.copyWith(walletsModel: state.walletsModel));
    });

    on<UpdateAccountName>((event, emit) async {
      for (WalletMenuModel walletModel in state.walletsModel) {
        if (walletModel.walletModel.serverWalletID ==
            event.walletModel.serverWalletID) {
          for (AccountMenuModel account in walletModel.accounts) {
            if (account.accountModel.serverAccountID ==
                event.accountModel.serverAccountID) {
              account.label = event.newName;
              break;
            }
          }
          break;
        }
      }
      emit(state.copyWith(walletsModel: state.walletsModel));
    });

    on<AddEmailIntegration>((event, emit) async {
      for (WalletMenuModel walletModel in state.walletsModel) {
        if (walletModel.walletModel.serverWalletID ==
            event.walletModel.serverWalletID) {
          for (AccountMenuModel account in walletModel.accounts) {
            if (account.accountModel.serverAccountID ==
                event.accountModel.serverAccountID) {
              if (account.emailIds.contains(event.emailID) == false) {
                account.emailIds.add(event.emailID);
              }
              break;
            }
          }
          break;
        }
      }
      emit(state.copyWith(walletsModel: state.walletsModel));
    });

    on<RemoveEmailIntegration>((event, emit) async {
      for (WalletMenuModel walletModel in state.walletsModel) {
        if (walletModel.walletModel.serverWalletID ==
            event.walletModel.serverWalletID) {
          for (AccountMenuModel account in walletModel.accounts) {
            if (account.accountModel.serverAccountID ==
                event.accountModel.serverAccountID) {
              account.emailIds.remove(event.emailID);
              break;
            }
          }
          break;
        }
      }
      emit(state.copyWith(walletsModel: state.walletsModel));
    });
  }

  void init({VoidCallback? callback}) {
    add(StartLoading(callback: callback));
  }

  void selectWallet(WalletModel wallet) {
    add(SelectWallet(wallet));
  }

  void selectAccount(WalletModel wallet, AccountModel acct) {
    add(SelectAccount(wallet, acct));
  }

  void updateWalletName(WalletModel wallet, String newName) {
    add(UpdateWalletName(wallet, newName));
  }

  void updateAccountName(
      WalletModel wallet, AccountModel acct, String newName) {
    add(UpdateAccountName(wallet, acct, newName));
  }

  void addEmailIntegration(
      WalletModel wallet, AccountModel acct, String emailID) {
    add(AddEmailIntegration(wallet, acct, emailID));
  }

  void removeEmailIntegration(
      WalletModel wallet, AccountModel acct, String emailID) {
    add(RemoveEmailIntegration(wallet, acct, emailID));
  }

  void updateAccountFiat(
      WalletModel wallet, AccountModel acct, String fiatName) {
    add(UpdateAccountFiat(wallet, acct, fiatName));
  }

  Future<bool> _hasValidPassphrase(
    WalletModel wallet,
    WalletPassphraseProvider walletPassProvider,
  ) async {
    // Check if the wallet requires a passphrase and if the passphrase is valid
    if (wallet.passphrase == 1) {
      final passphrase = await walletPassProvider.getWalletPassphrase(
        wallet.serverWalletID,
      );
      return passphrase != null;
    }
    // Default to false if none of the above conditions are met
    return true;
  }
}
