import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/constants/address.key.dart';
import 'package:wallet/constants/app.config.dart';
import 'package:wallet/constants/coin_type.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/network/api.helper.dart';
import 'package:wallet/rust/api/bdk_wallet.dart';
import 'package:wallet/rust/bdk/types.dart';
import 'package:wallet/constants/script_type.dart';
import 'package:wallet/helper/bdk/mnemonic.dart';
import 'package:wallet/helper/dbhelper.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/helper/secure_storage_helper.dart';
import 'package:wallet/constants/env.dart';
import 'package:wallet/helper/walletkey_helper.dart';
import 'package:wallet/models/account.model.dart';
import 'package:wallet/models/address.model.dart';
import 'package:wallet/models/contacts.model.dart';
import 'package:wallet/models/transaction.model.dart';
import 'package:wallet/models/wallet.model.dart';
import 'package:wallet/rust/proton_api/contacts.dart';
import 'package:wallet/rust/proton_api/exchange_rate.dart';
import 'package:wallet/rust/proton_api/proton_address.dart';
import 'package:wallet/rust/proton_api/user_settings.dart';
import 'package:wallet/rust/proton_api/wallet.dart';
import 'package:wallet/rust/proton_api/wallet_account.dart';
import 'package:wallet/scenes/debug/bdk.test.dart';
import 'package:wallet/rust/api/proton_api.dart' as proton_api;
import 'package:proton_crypto/proton_crypto.dart' as proton_crypto;
import 'package:http/http.dart' as http;

import 'bdk/helper.dart';

class WalletManager {
  static final BdkLibrary _lib = BdkLibrary(coinType: appConfig.coinType);
  static bool isFetchingWallets = false;
  static ApiEnv apiEnv = appConfig.apiEnv;

  static Future<Wallet> loadWalletWithID(int walletID, int accountID) async {
    late Wallet wallet;
    WalletModel walletModel = await DBHelper.walletDao!.findById(walletID);
    String passphrase =
        await SecureStorageHelper.instance.get(walletModel.serverWalletID);
    Mnemonic mnemonic = await Mnemonic.fromString(
        await WalletManager.getMnemonicWithID(walletID));
    final DerivationPath derivationPath = await DerivationPath.create(
        path: await getDerivationPathWithID(accountID));
    final aliceDescriptor = await _lib.createDerivedDescriptor(
        mnemonic, derivationPath,
        passphrase: passphrase);
    String derivationPathClean =
        derivationPath.toString().replaceAll("'", "_").replaceAll('/', '_');
    String dbName =
        "${walletModel.serverWalletID.replaceAll('-', '_').replaceAll('=', '_')}_${derivationPathClean}_${passphrase.isNotEmpty}";
    wallet = await _lib.restoreWallet(aliceDescriptor, databaseName: dbName);
    return wallet;
  }

  static Future<void> deleteWalletByServerWalletID(
      String serverWalletID) async {
    WalletModel? walletModel =
        await DBHelper.walletDao!.getWalletByServerWalletID(serverWalletID);
    if (walletModel != null) {
      await (deleteWallet(walletModel.id!));
    }
  }

  static Future<void> deleteWallet(int walletID) async {
    await DBHelper.walletDao!.delete(walletID);
    await DBHelper.accountDao!.deleteAccountsByWalletID(walletID);
  }

  static Future<int> getWalletIDByServerWalletID(String serverWalletID) async {
    WalletModel? walletModel =
        await DBHelper.walletDao!.getWalletByServerWalletID(serverWalletID);
    if (walletModel != null) {
      return walletModel.id!;
    }
    return -1;
  }

  static Future<void> addEmailAddressToWalletAccount(
      AccountModel accountModel, EmailAddress address) async {
    WalletModel walletModel =
        await DBHelper.walletDao!.findById(accountModel.walletID);
    AddressModel? addressModelExisted =
        await DBHelper.addressDao!.findByServerID(address.id);
    AddressModel addressModel = AddressModel(
      id: null,
      email: address.email,
      serverID: address.id,
      serverWalletID: walletModel.serverWalletID,
      serverAccountID: accountModel.serverAccountID,
    );
    if (addressModelExisted == null) {
      await DBHelper.addressDao!.insert(addressModel);
    }
  }

  static Future<void> removeEmailAddressInWalletAccount(
      EmailAddress address) async {
    await DBHelper.addressDao!.deleteByServerID(address.id);
  }

  static Future<void> autoCreateWallet() async {
    Mnemonic mnemonic = await Mnemonic.create(WordCount.words12);
    String strMnemonic = mnemonic.asString();

    SecretKey secretKey = WalletKeyHelper.generateSecretKey();
    String userPrivateKey =
        await SecureStorageHelper.instance.get("userPrivateKey");
    int passphrase = 0;
    String encryptedMnemonic =
        await WalletKeyHelper.encrypt(secretKey, strMnemonic);
    String walletName = "Default Wallet";
    Uint8List entropy = Uint8List.fromList(await secretKey.extractBytes());

    BdkWalletManager wallet = await BdkWalletManager.newInstance(
        network: appConfig.coinType.network, bip39Mnemonic: strMnemonic);

    String fingerprint = await wallet.getFingerprint();

    CreateWalletReq walletReq = CreateWalletReq(
      name: walletName,
      isImported: WalletModel.createByProton,
      type: WalletModel.typeOnChain,
      hasPassphrase: passphrase,
      userKeyId: APIHelper.userKeyID,
      walletKey: base64Encode(
          proton_crypto.encryptBinaryArmor(userPrivateKey, entropy)),
      fingerprint: fingerprint,
      mnemonic: encryptedMnemonic,
    );

    try {
      WalletData walletData =
          await proton_api.createWallet(walletReq: walletReq);
      String serverWalletID = walletData.wallet.id;
      int walletID = await WalletManager.insertOrUpdateWallet(
          userID: 0,
          name: walletName,
          encryptedMnemonic: encryptedMnemonic,
          passphrase: 0,
          imported: WalletModel.createByProton,
          priority: WalletModel.primary,
          status: WalletModel.statusActive,
          type: WalletModel.typeOnChain,
          serverWalletID: serverWalletID);
      await WalletManager.setWalletKey(serverWalletID,
          secretKey); // need to set key first, so that we can decrypt for walletAccount
      await addWalletAccount(walletID, appConfig.scriptType, "BTC Account");
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> insertOrUpdateAccount(int walletID, String labelEncrypted,
      int scriptType, String derivationPath, String serverAccountID) async {
    WalletModel walletModel = await DBHelper.walletDao!.findById(walletID);
    SecretKey? secretKey = await getWalletKey(walletModel.serverWalletID);
    if (walletID != -1 && secretKey != null) {
      DateTime now = DateTime.now();
      AccountModel? account =
          await DBHelper.accountDao!.findByServerAccountID(serverAccountID);
      if (account != null) {
        account.label = base64Decode(labelEncrypted);
        account.labelDecrypt =
            await WalletKeyHelper.decrypt(secretKey, labelEncrypted);
        account.modifyTime = now.millisecondsSinceEpoch ~/ 1000;
        account.scriptType = scriptType;
        await DBHelper.accountDao!.update(account);
      } else {
        account = AccountModel(
            id: null,
            walletID: walletID,
            derivationPath: derivationPath,
            label: base64Decode(labelEncrypted),
            scriptType: scriptType,
            createTime: now.millisecondsSinceEpoch ~/ 1000,
            modifyTime: now.millisecondsSinceEpoch ~/ 1000,
            serverAccountID: serverAccountID);
        account.labelDecrypt =
            await WalletKeyHelper.decrypt(secretKey, labelEncrypted);
        await DBHelper.accountDao!.insert(account);
      }
    }
  }

  static Future<int> insertOrUpdateWallet(
      {required int userID,
      required String name,
      required String encryptedMnemonic,
      required int passphrase,
      required int imported,
      required int priority,
      required int status,
      required int type,
      required String serverWalletID}) async {
    WalletModel? wallet =
        await DBHelper.walletDao!.getWalletByServerWalletID(serverWalletID);

    DateTime now = DateTime.now();
    if (wallet == null) {
      wallet = WalletModel(
          id: null,
          userID: userID,
          name: name,
          mnemonic: base64Decode(encryptedMnemonic),
          passphrase: passphrase,
          publicKey: Uint8List(0),
          imported: imported,
          priority: priority,
          status: status,
          type: type,
          fingerprint: "12345678",
          // TODO:: send correct fingerprint
          createTime: now.millisecondsSinceEpoch ~/ 1000,
          modifyTime: now.millisecondsSinceEpoch ~/ 1000,
          serverWalletID: serverWalletID);
      int walletID = await DBHelper.walletDao!.insert(wallet);
      return walletID;
    } else {
      wallet.name = name;
      wallet.status = status;
      await DBHelper.walletDao!.update(wallet);
      return wallet.id!;
    }
  }

  static Future<int> getAccountCount(int walletID) async {
    return DBHelper.accountDao!.getAccountCount(walletID);
  }

  static Future<bool> hasWallet() async {
    return await DBHelper.walletDao!.counts() > 0;
  }

  static Future<void> addWalletAccount(
      int walletID, ScriptType scriptType, String label,
      {int internal = 0}) async {
    WalletModel walletModel = await DBHelper.walletDao!.findById(walletID);
    String serverWalletID = walletModel.serverWalletID;
    SecretKey? secretKey = await getWalletKey(serverWalletID);
    if (secretKey == null) {
      logger.e("Can not get walletKey()\nwalletID: $walletID");
      return;
    }
    String derivationPath = await getNewDerivationPath(
        scriptType, walletID, appConfig.coinType,
        internal: internal);
    CreateWalletAccountReq req = CreateWalletAccountReq(
        label: await WalletKeyHelper.encrypt(secretKey, label),
        derivationPath: derivationPath,
        scriptType: appConfig.scriptType.index);
    WalletAccount walletAccount = await proton_api.createWalletAccount(
      walletId: serverWalletID,
      req: req,
    );

    await insertOrUpdateAccount(walletID, walletAccount.label, scriptType.index,
        "$derivationPath/$internal", walletAccount.id);
  }

  static Future<String> getNewDerivationPath(
      ScriptType scriptType, int walletID, CoinType coinType,
      {int internal = 0}) async {
    int accountIndex = 0;
    while (true) {
      String newDerivationPath =
          "m/${scriptType.bipVersion}'/${coinType.type}'/$accountIndex'";
      var result = await DBHelper.accountDao!
          .findByDerivationPath(walletID, "$newDerivationPath/$internal");
      if (result == null) {
        return newDerivationPath;
      }
      accountIndex++;
    }
  }

  static Future<String> getDerivationPathWithID(int accountID) async {
    AccountModel accountModel = await DBHelper.accountDao!.findById(accountID);
    return accountModel.derivationPath;
  }

  static Future<String> getAccountLabelWithID(int accountID) async {
    AccountModel accountModel = await DBHelper.accountDao!.findById(accountID);
    return accountModel.labelDecrypt;
  }

  static Future<String> getNameWithID(int walletID) async {
    String name = "Default Name";
    if (walletID == 0) {
      name = "Default Name";
    } else {
      WalletModel walletRecord = await DBHelper.walletDao!.findById(walletID);
      name = walletRecord.name;
    }
    return name;
  }

  static Future<double> getWalletAccountBalance(
      int walletID, int walletAccountID) async {
    Wallet wallet =
        await WalletManager.loadWalletWithID(walletID, walletAccountID);
    return (await wallet.getBalance()).total.toDouble();
  }

  static Future<double> getWalletBalance(int walletID) async {
    double balance = 0.0;
    List accounts = await DBHelper.accountDao!.findAllByWalletID(walletID);
    for (AccountModel accountModel in accounts) {
      balance += await getWalletAccountBalance(walletID, accountModel.id!);
    }
    return balance;
  }

  static Future<SecretKey?> getWalletKey(String serverWalletID) async {
    String keyPath = "${SecureStorageHelper.walletKey}_$serverWalletID";
    SecretKey secretKey;
    String encodedEntropy = await SecureStorageHelper.instance.get(keyPath);
    if (encodedEntropy.isEmpty) {
      return null;
    }
    secretKey =
        WalletKeyHelper.restoreSecretKeyFromEncodedEntropy(encodedEntropy);
    return secretKey;
  }

  static Future<void> setWalletKey(
      String serverWalletID, SecretKey secretKey) async {
    String keyPath = "${SecureStorageHelper.walletKey}_$serverWalletID";
    String encodedEntropy = await SecureStorageHelper.instance.get(keyPath);
    if (encodedEntropy.isEmpty) {
      encodedEntropy = await WalletKeyHelper.getEncodedEntropy(secretKey);
      await SecureStorageHelper.instance.set(keyPath, encodedEntropy);
    }
  }

  static Future<String> getMnemonicWithID(int walletID) async {
    WalletModel walletModel = await DBHelper.walletDao!.findById(walletID);
    SecretKey? secretKey = await getWalletKey(walletModel.serverWalletID);
    if (secretKey != null) {
      String mnemonic = await WalletKeyHelper.decrypt(
          secretKey, base64Encode(walletModel.mnemonic));
      return mnemonic;
    }
    return "";
  }

  static Future<ProtonExchangeRate> getExchangeRate(FiatCurrency fiatCurrency,
      {int? time}) async {
    ProtonExchangeRate exchangeRate = await proton_api.getExchangeRate(
        fiatCurrency: fiatCurrency, time: time);
    return exchangeRate;
  }

  static Future<void> saveUserSetting(ApiUserSettings userSettings) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(userSettingsHideEmptyUsedAddresses,
        userSettings.hideEmptyUsedAddresses);
    preferences.setInt(userSettingsTwoFactorAmountThreshold,
        userSettings.twoFactorAmountThreshold ?? 0);
    preferences.setInt(
        userSettingsShowWalletRecovery, userSettings.showWalletRecovery);
    preferences.setString(
        userSettingsFiatCurrency, userSettings.fiatCurrency.name.toUpperCase());
    preferences.setString(
        userSettingsBitcoinUnit, userSettings.bitcoinUnit.name.toUpperCase());
  }

  static int getCurrentTime() {
    return DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  }

  static Future<void> initContacts() async {
    List<ProtonContactEmails> mails = await proton_api.getContacts();
    for (ProtonContactEmails mail in mails) {
      DBHelper.contactsDao!.insertOrUpdate(
          mail.id, mail.name, mail.email, mail.canonicalEmail, mail.isProton);
    }
  }

  static Future<List<ContactsModel>> getContacts() async {
    List contacts = await DBHelper.contactsDao!.findAll();
    return contacts.cast<ContactsModel>();
  }

  static Future<List<String>> getAccountAddressIDs(
      String serverAccountID) async {
    List<AddressModel> result =
        await DBHelper.addressDao!.findByServerAccountID(serverAccountID);
    return result.map((e) => e.serverID).toList();
  }

  static Future<void> deleteAddress(String addressID) async {
    await DBHelper.addressDao!.deleteByServerID(addressID);
  }

  static Future<void> autoBindEmailAddresses() async {
    int walletCounts = await DBHelper.walletDao!.counts();
    if (walletCounts > 1) {
      return;
    }
    logger.i("Auto binding email address..");
    List<ProtonAddress> protonAddresses = await proton_api.getProtonAddress();
    protonAddresses =
        protonAddresses.where((element) => element.status == 1).toList();
    WalletModel? walletModel =
        await DBHelper.walletDao!.getFirstPriorityWallet();
    if (walletModel != null) {
      List<AccountModel> accountModels =
          (await DBHelper.accountDao!.findAllByWalletID(walletModel.id!))
              .cast<AccountModel>();
      AccountModel? accountModel = accountModels.firstOrNull;
      if (accountModel != null) {
        for (ProtonAddress protonAddress in protonAddresses) {
          await addEmailAddress(walletModel.serverWalletID,
              accountModel.serverAccountID, protonAddress.id);
        }
      }
    }
  }

  static Future<void> addEmailAddress(String serverWalletID,
      String serverAccountID, String serverAddressID) async {
    try {
      WalletAccount walletAccount = await proton_api.addEmailAddress(
          walletId: serverWalletID,
          walletAccountId: serverAccountID,
          addressId: serverAddressID);
      AccountModel accountModel =
          await DBHelper.accountDao!.findByServerAccountID(serverAccountID);
      for (EmailAddress address in walletAccount.addresses) {
        await WalletManager.addEmailAddressToWalletAccount(
            accountModel, address);
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  static Future<void> fetchWalletsFromServer() async {
    if (isFetchingWallets) {
      return;
    }
    isFetchingWallets = true;
    // var authInfo = await fetchAuthInfo(userName: 'ProtonWallet');
    List<WalletData> wallets = await proton_api.getWallets();
    for (WalletData walletData in wallets.reversed) {
      WalletModel? walletModel = await DBHelper.walletDao!
          .getWalletByServerWalletID(walletData.wallet.id);
      String userPrivateKey =
          await SecureStorageHelper.instance.get("userPrivateKey");
      String userPassphrase =
          await SecureStorageHelper.instance.get("userPassphrase");

      String encodedEncryptedEntropy = "";
      Uint8List entropy = Uint8List(0);
      try {
        encodedEncryptedEntropy = walletData.walletKey.walletKey;
        entropy = proton_crypto.decryptBinary(userPrivateKey, userPassphrase,
            base64Decode(encodedEncryptedEntropy));
      } catch (e) {
        logger.e(e.toString());
      }
      SecretKey secretKey =
          WalletKeyHelper.restoreSecretKeyFromEntropy(entropy);
      if (walletModel == null) {
        String serverWalletID = walletData.wallet.id;
        // int status = entropy.isNotEmpty
        //     ? WalletModel.statusActive
        //     : WalletModel.statusDisabled;
        int status = WalletModel.statusActive;
        int walletID = await WalletManager.insertOrUpdateWallet(
            userID: 0,
            name: walletData.wallet.name,
            encryptedMnemonic: walletData.wallet.mnemonic!,
            passphrase: walletData.wallet.hasPassphrase,
            imported: walletData.wallet.isImported,
            priority: walletData.wallet.priority,
            status: status,
            type: walletData.wallet.type,
            serverWalletID: serverWalletID);
        walletModel = await DBHelper.walletDao!
            .getWalletByServerWalletID(walletData.wallet.id);
        if (entropy.isNotEmpty) {
          await WalletManager.setWalletKey(serverWalletID,
              secretKey); // need to set key first, so that we can decrypt for walletAccount
          List<WalletAccount> walletAccounts = await proton_api
              .getWalletAccounts(walletId: walletData.wallet.id);
          if (walletAccounts.isNotEmpty) {
            for (WalletAccount walletAccount in walletAccounts) {
              await WalletManager.insertOrUpdateAccount(
                walletID,
                walletAccount.label,
                walletAccount.scriptType,
                "${walletAccount.derivationPath}/0",
                walletAccount.id,
              );
              AccountModel accountModel = await DBHelper.accountDao!
                  .findByServerAccountID(walletAccount.id);
              for (EmailAddress address in walletAccount.addresses) {
                WalletManager.addEmailAddressToWalletAccount(
                    accountModel, address);
              }
            }
          }
        }
      } else {
        if (entropy.isNotEmpty) {
          List<String> existingAccountIDs = [];
          List<WalletAccount> walletAccounts = await proton_api
              .getWalletAccounts(walletId: walletData.wallet.id);
          if (walletAccounts.isNotEmpty) {
            for (WalletAccount walletAccount in walletAccounts) {
              existingAccountIDs.add(walletAccount.id);
              await WalletManager.insertOrUpdateAccount(
                  walletModel.id!,
                  walletAccount.label,
                  walletAccount.scriptType,
                  "${walletAccount.derivationPath}/0",
                  walletAccount.id);
              AccountModel accountModel = await DBHelper.accountDao!
                  .findByServerAccountID(walletAccount.id);
              for (EmailAddress address in walletAccount.addresses) {
                WalletManager.addEmailAddressToWalletAccount(
                    accountModel, address);
              }
            }
          }
          try {
            if (walletModel.accountCount != walletAccounts.length) {
              DBHelper.accountDao!.deleteAccountsNotInServers(
                  walletModel.id!, existingAccountIDs);
            }
          } catch (e) {
            e.toString();
          }
        } else {
          walletModel.status = WalletModel.statusDisabled;
          DBHelper.walletDao!.update(walletModel);
        }
      }
    }
    await fetchWalletTransactions();
    isFetchingWallets = false;
  }

  static Future<void> setLatestEventId(String latestEventId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("latestEventId", latestEventId);
  }

  static Future<String?> getLatestEventId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("latestEventId");
  }

  static Future<void> initMuon(ApiEnv apiEnv) async {
    WalletManager.apiEnv = apiEnv;
    String scopes = await SecureStorageHelper.instance.get("scopes");
    String uid = await SecureStorageHelper.instance.get("sessionId");
    String accessToken = await SecureStorageHelper.instance.get("accessToken");
    String refreshToken =
        await SecureStorageHelper.instance.get("refreshToken");
    String appVersion = "Other";
    String userAgent = "None";
    if (Platform.isWindows || Platform.isLinux) {
      // user "pro"
      uid = '4spy6qcvejmt2eca2o77kpegd4nprmzl';
      accessToken = 'o7ktm37f52t7koidvgrnqpyek7ljfwyh';
      refreshToken = 'rfwiho5iz6m2a6h75y63xw4yc6hvnfak';
      //
      // user "qqqq"
      // uid = "pb77kwsitejue43sybqwytlu7mkaaf24";
      // accessToken = "vtwkhh75r377lnl3jphsiocvbdp5p47n";
      // refreshToken = "chn52wqi25red7sjotxnzkkhj4em4yne";
    }
    logger.i("uid = '$uid';");
    logger.i("accessToken = '$accessToken';");
    logger.i("refreshToken = '$refreshToken';");
    if (Platform.isAndroid) {
      appVersion = await SecureStorageHelper.instance.get("appVersion");
      userAgent = await SecureStorageHelper.instance.get("userAgent");
    }
    if (Platform.isIOS) {
      appVersion = "android-wallet@1.0.0";
      userAgent = "ProtonWallet/1.0.0 (iOS/17.4; arm64)";
    }
    await proton_api.initApiServiceFromAuthAndVersion(
      uid: uid,
      access: accessToken,
      refresh: refreshToken,
      scopes: scopes.split(","),
      appVersion: appVersion,
      userAgent: userAgent,
      env: apiEnv.toString(),
    );
  }

  static Future<String?> lookupBitcoinAddress(String email) async {
    EmailIntegrationBitcoinAddress emailIntegrationBitcoinAddress =
        await proton_api.lookupBitcoinAddress(email: email);
    // TODO:: check signature!
    return emailIntegrationBitcoinAddress.bitcoinAddress;
  }

  static Future<List<AddressKey>> getAddressKeys() async {
    List<ProtonAddress> addresses = await proton_api.getProtonAddress();
    addresses = addresses.where((element) => element.status == 1).toList();

    String userPrivateKey =
        await SecureStorageHelper.instance.get("userPrivateKey");
    String userPassphrase =
        await SecureStorageHelper.instance.get("userPassphrase");
    List<AddressKey> addressKeys = [];
    for (ProtonAddress address in addresses) {
      for (ProtonAddressKey addressKey in address.keys ?? []) {
        String addressKeyPrivateKey = addressKey.privateKey ?? "";
        String addressKeyToken = addressKey.token ?? "";
        try {
          String addressKeyPassphrase = proton_crypto.decrypt(
              userPrivateKey, userPassphrase, addressKeyToken);
          addressKeys.add(AddressKey(
              privateKey: addressKeyPrivateKey,
              passphrase: addressKeyPassphrase));
        } catch (e) {
          logger.e(e.toString());
        }
      }
    }
    return addressKeys;
  }

  static Future<void> fetchWalletTransactions() async {
    List<AddressKey> addressKeys = await getAddressKeys();
    List<WalletModel> wallets =
        (await DBHelper.walletDao!.findAll()).cast<WalletModel>();

    for (WalletModel walletModel in wallets) {
      await handleWalletTransactions(walletModel, addressKeys);
    }
  }

  static Future<void> handleWalletTransactions(
      WalletModel walletModel, List<AddressKey> addressKeys) async {
    List<WalletTransaction> walletTransactions = await proton_api
        .getWalletTransactions(walletId: walletModel.serverWalletID);

    for (WalletTransaction walletTransaction in walletTransactions) {
      await handleWalletTransaction(
          walletModel, addressKeys, walletTransaction);
    }
  }

  static Future<void> handleWalletTransaction(WalletModel walletModel,
      List<AddressKey> addressKeys, WalletTransaction walletTransaction) async {
    DateTime now = DateTime.now();
    String txid = "";
    for (AddressKey addressKey in addressKeys) {
      try {
        txid = addressKey.decrypt(walletTransaction.transactionId);
        if (txid.isNotEmpty) {
          break;
        }
      } catch (e) {
        logger.e(e.toString());
      }
    }
    if (txid.isEmpty) {
      String userPrivateKey =
      await SecureStorageHelper.instance.get("userPrivateKey");
      String userPassphrase =
      await SecureStorageHelper.instance.get("userPassphrase");
      txid = proton_crypto.decrypt(userPrivateKey, userPassphrase, walletTransaction.transactionId);
    }
    String exchangeRateID = "";
    if (walletTransaction.exchangeRate != null) {
      exchangeRateID = walletTransaction.exchangeRate!.id;
    }
    TransactionModel transactionModel = TransactionModel(
        id: null,
        walletID: walletModel.id!,
        label: utf8.encode(walletTransaction.label ?? ""),
        externalTransactionID: utf8.encode(txid),
        createTime: now.millisecondsSinceEpoch ~/ 1000,
        modifyTime: now.millisecondsSinceEpoch ~/ 1000,
        hashedTransactionID:
            utf8.encode(walletTransaction.hashedTransactionId ?? ""),
        transactionID: walletTransaction.id,
        transactionTime: walletTransaction.transactionTime,
        exchangeRateID: exchangeRateID,
        serverWalletID: walletTransaction.walletId,
        serverAccountID: walletTransaction.walletAccountId!,
        sender: walletTransaction.sender,
        tolist: walletTransaction.tolist,
        subject: walletTransaction.subject,
        body: walletTransaction.body);
    await DBHelper.transactionDao!.insertOrUpdate(transactionModel);
  }

  static Future<void> handleBitcoinAddressRequests(
      Wallet wallet, String serverWalletID, String serverAccountID) async {
    // TODO:: compute signature!
    List<WalletBitcoinAddress> walletBitcoinAddresses =
        await proton_api.getWalletBitcoinAddress(
            walletId: serverWalletID,
            walletAccountId: serverAccountID,
            onlyRequest: 1);
    for (WalletBitcoinAddress walletBitcoinAddress in walletBitcoinAddresses) {
      if (walletBitcoinAddress.bitcoinAddress == null) {
        var addressInfo = await _lib.getAddress(wallet);
        String address = addressInfo.address;
        BitcoinAddress bitcoinAddress = BitcoinAddress(
            bitcoinAddress: address,
            bitcoinAddressSignature:
                "-----BEGIN PGP SIGNATURE-----\nVersion: ProtonMail\n\nwsBzBAEBCAAnBYJmA55ZCZAEzZ3CX7rlCRYhBFNy3nIbmXFRgnNYHgTNncJf\nuuUJAAAQAgf9EicFZ9NfoTbXc0DInR3fXHgcpQj25Z0uaapvvPMpWwmMSoKp\nm4WrWkWnX/VOizzfwfmSTeLYN8dkGytHACqj1AyEkpSKTbpsYn+BouuNQmat\nYhUnnlT6LLcjDAxv5FU3cDxB6wMmoFZwxu+XsS+zwfldxVp7rq3PNQE/mUzn\no0qf9WcE7vRDtoYu8I26ILwYUEiXgXMvGk5y4mz9P7+UliH7R1/qcFdZoqe4\n4f/cAStdFOMvm8hGk/wIZ/an7lDxE+ggN1do9Vjs2eYVQ8LwwE96Xj5Ny7s5\nFlajisB2YqgTMOC5egrwXE3lxKy2O3TNw1FCROQUR0WaumG8E0foRg==\n=42uQ\n-----END PGP SIGNATURE-----\n",
            bitcoinAddressIndex: 0);
        await proton_api.updateBitcoinAddress(
            walletId: serverWalletID,
            walletAccountId: serverAccountID,
            walletAccountBitcoinAddressId: walletBitcoinAddress.id,
            bitcoinAddress: bitcoinAddress);
      }
    }
  }

  static Future<void> bitcoinAddressPoolHealthCheck(
      Wallet wallet, String serverWalletID, String serverAccountID) async {
    // TODO:: compute signature!
    int unFetchedBitcoinAddressCount = 0;
    List<WalletBitcoinAddress> walletBitcoinAddresses =
        await proton_api.getWalletBitcoinAddress(
            walletId: serverWalletID,
            walletAccountId: serverAccountID,
            onlyRequest: 0);
    for (WalletBitcoinAddress walletBitcoinAddress in walletBitcoinAddresses) {
      if (walletBitcoinAddress.fetched == 0 && walletBitcoinAddress.used == 0) {
        unFetchedBitcoinAddressCount++;
      }
    }
    int addingCount = max(0,
        defaultBitcoinAddressCountForOneEmail - unFetchedBitcoinAddressCount);
    // let pool remain `defaultBitcoinAddressCountForOneEmail` unfetched(also unused) bitcoinAddresses
    for (int _ = 0; _ < addingCount; _++) {
      var addressInfo = await _lib.getAddress(wallet);
      String address = addressInfo.address;
      BitcoinAddress bitcoinAddress = BitcoinAddress(
          bitcoinAddress: address,
          bitcoinAddressSignature:
              "-----BEGIN PGP SIGNATURE-----\nVersion: ProtonMail\n\nwsBzBAEBCAAnBYJmA55ZCZAEzZ3CX7rlCRYhBFNy3nIbmXFRgnNYHgTNncJf\nuuUJAAAQAgf9EicFZ9NfoTbXc0DInR3fXHgcpQj25Z0uaapvvPMpWwmMSoKp\nm4WrWkWnX/VOizzfwfmSTeLYN8dkGytHACqj1AyEkpSKTbpsYn+BouuNQmat\nYhUnnlT6LLcjDAxv5FU3cDxB6wMmoFZwxu+XsS+zwfldxVp7rq3PNQE/mUzn\no0qf9WcE7vRDtoYu8I26ILwYUEiXgXMvGk5y4mz9P7+UliH7R1/qcFdZoqe4\n4f/cAStdFOMvm8hGk/wIZ/an7lDxE+ggN1do9Vjs2eYVQ8LwwE96Xj5Ny7s5\nFlajisB2YqgTMOC5egrwXE3lxKy2O3TNw1FCROQUR0WaumG8E0foRg==\n=42uQ\n-----END PGP SIGNATURE-----\n",
          bitcoinAddressIndex: addressInfo.index);
      await proton_api.addBitcoinAddresses(
          walletId: serverWalletID,
          walletAccountId: serverAccountID,
          bitcoinAddresses: [bitcoinAddress]);
    }
  }

  static String getEmailFromWalletTransaction(String jsonString) {
    try {
      var jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList[0].values.first;
    } catch (e) {
      try {
        var jsonList = jsonDecode(jsonString) as Map<String, dynamic>;
        return jsonList.values.toList()[0];
      } catch (e) {
        return jsonString;
      }
    }
  }

  static String getBitcoinAddressFromWalletTransaction(String jsonString) {
    try {
      var jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList[0].keys.first;
    } catch (e) {
      try {
        var jsonList = jsonDecode(jsonString) as Map<String, dynamic>;
        return jsonList.keys.toList()[0];
      } catch (e) {
        return jsonString;
      }
    }
  }

  static Future<Map<String, dynamic>> getTransactionDetailsFromBlockStream(
      String txid) async {
    String baseUrl = "${appConfig.esploraBaseUrl}api";
    final response = await http.get(Uri.parse('$baseUrl/tx/$txid'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return {
        'transaction_id': txid,
        'block_height': data['status']['block_height'],
        'timestamp': data['status']['block_time'],
        'outputs': data['vout']
            .map((output) => {
                  'address': output['scriptpubkey_address'],
                  'value': output['value']
                })
            .toList(),
        'fees': data['fee'],
      };
    } else {
      return {};
    }
  }
}
