import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sentry/sentry.dart';
import 'package:wallet/constants/app.config.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/script_type.dart';
import 'package:wallet/helper/common_helper.dart';
import 'package:wallet/helper/dbhelper.dart';
import 'package:wallet/helper/exceptions.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/managers/features/create.wallet.bloc.dart';
import 'package:wallet/managers/providers/data.provider.manager.dart';
import 'package:wallet/managers/providers/wallet.data.provider.dart';
import 'package:wallet/managers/wallet/wallet.manager.dart';
import 'package:wallet/models/account.model.dart';
import 'package:wallet/models/drift/db/app.database.dart';
import 'package:wallet/models/wallet.model.dart';
import 'package:wallet/rust/api/bdk_wallet/mnemonic.dart';
import 'package:wallet/rust/api/proton_api.dart' as proton_api;
import 'package:wallet/rust/common/errors.dart';
import 'package:wallet/rust/common/network.dart';
import 'package:wallet/rust/proton_api/proton_address.dart';
import 'package:wallet/rust/proton_api/user_settings.dart';
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart';
import 'package:wallet/scenes/core/viewmodel.dart';
import 'package:wallet/scenes/import/import.coordinator.dart';

abstract class ImportViewModel extends ViewModel<ImportCoordinator> {
  ImportViewModel(
    super.coordinator,
    this.dataProviderManager,
  );

  final DataProviderManager dataProviderManager;
  late TextEditingController mnemonicTextController;
  late TextEditingController nameTextController;
  late TextEditingController passphraseTextController;
  late FocusNode mnemonicFocusNode;
  late FocusNode nameFocusNode;
  late FocusNode passphraseFocusNode;
  late ValueNotifier<FiatCurrency> fiatCurrencyNotifier;

  bool isPasteMode = true;
  String errorMessage = "";
  bool isValidMnemonic = false;
  bool isFirstWallet = false;
  bool isImporting = false;
  bool acceptTermsAndConditions = false;
  List<ProtonAddress> protonAddresses = [];

  void switchToManualInputMode();

  void switchToPasteMode();

  void updateValidMnemonic({required bool isValidMnemonic});

  (bool, String) mnemonicValidation(String strMnemonic);

  Future<void> importWallet();
}

class ImportViewModelImpl extends ImportViewModel {
  final String preInputWalletName;

  final CreateWalletBloc createWalletBloc;

  ImportViewModelImpl(
    super.coordinator,
    super.dataProviderManager,
    this.preInputWalletName,
    this.createWalletBloc,
  );

  @override
  Future<void> loadData() async {
    mnemonicTextController = TextEditingController();
    nameTextController = TextEditingController();
    passphraseTextController = TextEditingController();
    mnemonicFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    passphraseFocusNode = FocusNode();
    fiatCurrencyNotifier = ValueNotifier(defaultFiatCurrency);
    nameTextController.text = preInputWalletName;
    final WalletUserSettings? walletUserSettings =
        await dataProviderManager.userSettingsDataProvider.getSettings();
    if (walletUserSettings != null) {
      acceptTermsAndConditions = walletUserSettings.acceptTermsAndConditions;
    }

    final List<ProtonAddress> addresses = await proton_api.getProtonAddress();
    protonAddresses =
        addresses.where((element) => element.status == 1).toList();

    final List<WalletData>? wallets =
        await dataProviderManager.walletDataProvider.getWallets();
    if (wallets == null) {
      isFirstWallet = true;
    } else if (wallets.isEmpty) {
      isFirstWallet = true;
    }
  }

  @override
  Future<void> importWallet() async {
    WalletModel? walletModel;
    AccountModel? accountModel;
    try {
      final String walletName = nameTextController.text;
      // Validation for walletName if empty
      // if (walletName.isEmpty) throw Exception("Wallet name cannot be empty");
      final String strMnemonic = mnemonicTextController.text;
      final String strPassphrase = passphraseTextController.text;
      final Network network = appConfig.coinType.network;
      final ScriptTypeInfo scriptTypeInfo = appConfig.scriptTypeInfo;

      final apiWallet = await createWalletBloc.createWallet(
        walletName,
        strMnemonic,
        network,
        WalletModel.importByUser,
        strPassphrase,
      );

      final apiWalletAccount = await createWalletBloc.createWalletAccount(
        apiWallet.wallet.id,
        scriptTypeInfo,
        "Primary Account",
        fiatCurrencyNotifier.value,
        0, // default wallet account index
      );
      final String walletID = apiWallet.wallet.id;
      final String accountID = apiWalletAccount.id;
      walletModel = await DBHelper.walletDao!.findByServerID(walletID);
      accountModel = await DBHelper.accountDao!.findByServerID(accountID);
      if (isFirstWallet) {
        /// Auto bind email address if it's first wallet
        if (walletModel != null && accountModel != null) {
          final ProtonAddress? protonAddress = protonAddresses.firstOrNull;
          if (protonAddress != null) {
            await addEmailAddressToWalletAccount(
              walletID,
              walletModel,
              accountModel,
              protonAddress.id,
            );
          }
        }
      }
    } on BridgeError catch (e, stacktrace) {
      errorMessage = parseSampleDisplayError(e);
      logger.e("importWallet error: $e, stacktrace: $stacktrace");
      Sentry.captureException(e, stackTrace: stacktrace);
    } catch (e, stacktrace) {
      logger.e("importWallet error: $e, stacktrace: $stacktrace");
      Sentry.captureException(e, stackTrace: stacktrace);
    }
    if (walletModel != null && accountModel != null) {
      dataProviderManager.bdkTransactionDataProvider.syncWallet(
        walletModel,
        accountModel,
        forceSync: true,
      );
    }
  }

  @override
  Future<void> move(NavID to) async {}

  Future<void> addEmailAddressToWalletAccount(
    String serverWalletID,
    WalletModel walletModel,
    AccountModel accountModel,
    String serverAddressID,
  ) async {
    try {
      await WalletManager.addEmailAddress(
        serverWalletID,
        accountModel.accountID,
        serverAddressID,
      );
      dataProviderManager.walletDataProvider.notifyUpdateEmailIntegration();
    } catch (e) {
      errorMessage = e.toString();
    }
    if (errorMessage.isNotEmpty) {
      CommonHelper.showErrorDialog(errorMessage);
      errorMessage = "";
    }
  }

  @override
  void switchToManualInputMode() {
    isPasteMode = false;
    sinkAddSafe();
  }

  @override
  void switchToPasteMode() {
    isPasteMode = true;
    sinkAddSafe();
  }

  @override
  void updateValidMnemonic({required bool isValidMnemonic}) {
    this.isValidMnemonic = isValidMnemonic;
    sinkAddSafe();
  }

  @override
  (bool, String) mnemonicValidation(String strMnemonic) {
    final mnemonicLength = strMnemonic.split(" ");
    final length = mnemonicLength.length;
    for (var i = 0; i < mnemonicLength.length; i++) {
      final word = mnemonicLength[i];
      if (!FrbMnemonic.getWordsAutocomplete(wordStart: word)
          .contains(mnemonicLength[i])) {
        final pending = "\nWord: `$word`";
        return (false, pending);
      }
    }
    if (length != 12 && length != 18 && length != 24) {
      logger.i("length not match! ($mnemonicLength)");
      final pending = "\nLength: $length";
      return (false, pending);
    }

    return (true, "");
  }
}
