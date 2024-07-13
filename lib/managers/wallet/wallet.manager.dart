import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:proton_crypto/proton_crypto.dart' as proton_crypto;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/constants/address.key.dart';
import 'package:wallet/constants/app.config.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/transaction.detail.from.blockchain.dart';
import 'package:wallet/helper/bdk/bdk.library.dart';
import 'package:wallet/helper/common_helper.dart';
import 'package:wallet/helper/dbhelper.dart';
import 'package:wallet/helper/extension/data.dart';
import 'package:wallet/helper/extension/enum.extension.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/helper/walletkey_helper.dart';
import 'package:wallet/managers/manager.dart';
import 'package:wallet/managers/providers/local.bitcoin.address.provider.dart';
import 'package:wallet/managers/providers/server.transaction.data.provider.dart';
import 'package:wallet/managers/providers/wallet.data.provider.dart';
import 'package:wallet/managers/providers/wallet.keys.provider.dart';
import 'package:wallet/managers/providers/wallet.passphrase.provider.dart';
import 'package:wallet/managers/users/user.manager.dart';
import 'package:wallet/managers/wallet/proton.wallet.manager.dart';
import 'package:wallet/models/account.model.dart';
import 'package:wallet/models/address.model.dart';
import 'package:wallet/models/wallet.model.dart';
import 'package:wallet/rust/api/bdk_wallet/account.dart';
import 'package:wallet/rust/api/bdk_wallet/address.dart';
import 'package:wallet/rust/api/bdk_wallet/balance.dart';
import 'package:wallet/rust/api/bdk_wallet/storage.dart';
import 'package:wallet/rust/api/bdk_wallet/wallet.dart';
import 'package:wallet/rust/api/proton_api.dart' as proton_api;
import 'package:wallet/rust/proton_api/exchange_rate.dart';
import 'package:wallet/rust/proton_api/proton_address.dart';
import 'package:wallet/rust/proton_api/user_settings.dart';
import 'package:wallet/rust/proton_api/wallet.dart';
import 'package:wallet/rust/proton_api/wallet_account.dart';

// this is service // per wallet account
class WalletManager implements Manager {
  static final BdkLibrary bdkLib = BdkLibrary();
  static bool isFetchingWallets = false;

  // TODO(fix): fix me
  static late UserManager userManager;
  static late ProtonWalletManager protonWallet;

  /// setup in data provider login function
  static late WalletKeysProvider walletKeysProvider;
  static late WalletPassphraseProvider walletPassphraseProvider;
  static late WalletsDataProvider walletDataProvider;
  static late LocalBitcoinAddressDataProvider localBitcoinAddressDataProvider;
  static late ServerTransactionDataProvider serverTransactionDataProvider;
  static late String userID;

  ///
  static HashMap<String, FrbWallet> frbWallets = HashMap<String, FrbWallet>();

  // TODO(fix): before new_wallet need to check if network changed. if yes need to delete the wallet and create a new one
  // TODO(fix): return Wallet? to avoid issue, add try-catch here
  static Future<FrbAccount?> loadWalletWithID(
    String walletID,
    String accountID,
  ) async {
    final WalletModel? walletModel =
        await DBHelper.walletDao!.findByServerID(walletID);
    if (walletModel == null) return null;
    final walletServerID = walletModel.walletID;

    var frbWallet = frbWallets[walletServerID];
    if (frbWallet == null) {
      // try restore wallet first;
      final passphrase = await walletPassphraseProvider.getPassphrase(
        walletServerID,
      );
      final mnemonic = await WalletManager.getMnemonicWithID(walletID);
      if (walletModel.passphrase == 1 && passphrase == null) {
        /// wallet has passphrase, but user didn't set correct passphrase yet
        return null;
      }
      frbWallet = FrbWallet(
        network: appConfig.coinType.network,
        bip39Mnemonic: mnemonic,
        bip38Passphrase: passphrase,
      );
      frbWallets[walletModel.walletID] = frbWallet;
    }

    final String derivationPath = await getDerivationPathWithID(accountID);
    final found = frbWallet.getAccount(derivationPath: derivationPath);
    if (found != null) {
      return found;
    }

    final dbPath = await _getDatabaseFolderPath();
    final storage = OnchainStoreFactory(folderPath: dbPath);

    final account = frbWallet.addAccount(
        scriptType: appConfig.scriptTypeInfo.type,
        derivationPath: derivationPath,
        storageFactory: storage);

    return account;
  }

  // TODO(fix): fix me .temp move to better place
  static Future<Directory> _getDatabaseFolder() async {
    const dbFolder = "databases";
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final folderPath = Directory(p.join(appDocumentsDir.path, dbFolder));

    if (!folderPath.existsSync()) {
      await folderPath.create(recursive: true);
    }
    return folderPath;
  }

  // TODO(fix): fix me .temp move to better place
  static Future<String> _getDatabaseFolderPath() async {
    final folder = await _getDatabaseFolder();
    return folder.path;
  }

  ///
  static Future<void> cleanBDKCache() async {
    frbWallets.clear();
    bdkLib.clearLocalCache();
    // TODO(fix): add clear cache to bdk library
  }

  static Future<void> cleanSharedPreference() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static Future<List<ProtonAddress>> getProtonAddress() async {
    return proton_api.getProtonAddress();
  }

  // static Future<void> addEmailAddressToWalletAccount(
  //   String serverWalletID,
  //   String serverAccountID,
  //   ApiEmailAddress address,
  // ) async {
  //   AddressModel? addressModel =
  //       await DBHelper.addressDao!.findByServerID(address.id);
  //   if (addressModel == null) {
  //     addressModel = AddressModel(
  //       id: -1,
  //       email: address.email,
  //       serverID: address.id,
  //       serverWalletID: serverWalletID,
  //       serverAccountID: serverAccountID,
  //     );
  //     await DBHelper.addressDao!.insert(addressModel);
  //   } else {
  //     addressModel.email = address.email;
  //     addressModel.serverID = address.id;
  //     addressModel.serverWalletID = serverWalletID;
  //     addressModel.serverAccountID = serverAccountID;
  //     await DBHelper.addressDao!.update(addressModel);
  //   }
  // }

  static Future<void> removeEmailAddressInWalletAccount(
      ApiEmailAddress address) async {
    await DBHelper.addressDao!.deleteByServerID(address.id);
  }

  static Future<String> getFingerPrintFromMnemonic(String strMnemonic,
      {String? passphrase}) async {
    final wallet = FrbWallet(
        network: appConfig.coinType.network,
        bip39Mnemonic: strMnemonic,
        bip38Passphrase: passphrase);
    final String fingerprint = wallet.getFingerprint();
    logger.i("fingerprint = $fingerprint");
    return fingerprint;
  }

  static CreateWalletReq buildWalletRequest(
      String encryptedName,
      int type,
      String mnemonic,
      String fingerprint,
      String userKey,
      String userKeyID,
      String encryptedWalletKey,
      String walletKeySignature,
      {required bool hasPassphrase}) {
    return CreateWalletReq(
      name: encryptedName,
      isImported: type,
      type: WalletModel.typeOnChain,
      hasPassphrase: hasPassphrase ? 1 : 0,
      userKeyId: userKeyID,
      walletKey: encryptedWalletKey,
      //proton_crypto.encryptBinaryArmor(userKey, entropy),
      fingerprint: fingerprint,
      mnemonic: mnemonic,
      walletKeySignature: walletKeySignature,
      isAutoCreated: 0,
    );
  }

  static Future<int> getAccountCount(String walletID) async {
    return DBHelper.accountDao!.getAccountCount(walletID);
  }

  static Future<bool> hasWallet(String userID) async {
    return await DBHelper.walletDao!.counts(userID) > 0;
  }

  static Future<String> getDerivationPathWithID(String accountID) async {
    final AccountModel accountModel =
        await DBHelper.accountDao!.findByServerID(accountID);
    logger.w("$accountID: ${accountModel.derivationPath}");
    return accountModel.derivationPath;
  }

  static Future<String> getAccountLabelWithID(String accountID) async {
    final AccountModel accountModel =
        await DBHelper.accountDao!.findByServerID(accountID);
    final SecretKey secretKey = await getWalletKey(accountModel.walletID);
    await accountModel.decrypt(secretKey);
    return accountModel.labelDecrypt;
  }

  static Future<String> getNameWithID(String walletID) async {
    String name = "Default Name";
    final WalletModel walletRecord =
        await DBHelper.walletDao!.findByServerID(walletID);
    name = walletRecord.name;
    return name;
  }

  static Future<int> getWalletAccountBalance(
    String walletID,
    String walletAccountID,
  ) async {
    try {
      final FrbAccount? frbAccount = await WalletManager.loadWalletWithID(
        walletID,
        walletAccountID,
      );
      if (frbAccount == null) {
        logger.e("getWalletAccountBalance account is null");
        return 0;
      }

      final FrbBalance balance = await frbAccount.getBalance();

      return balance.trustedSpendable().toSat().toInt();
    } catch (e) {
      logger.e(e.toString());
    }
    return 0;
  }

  static Future<double> getWalletBalance(String walletID) async {
    double balance = 0.0;
    final List accounts =
        await DBHelper.accountDao!.findAllByWalletID(walletID);
    for (AccountModel accountModel in accounts) {
      balance += await getWalletAccountBalance(walletID, accountModel.walletID);
    }
    return balance;
  }

  static Future<String> getMnemonicWithID(String walletID) async {
    final WalletModel walletModel =
        await DBHelper.walletDao!.findByServerID(walletID);
    final firstUserKey = await userManager.getFirstKey();
    final walletKey = await walletKeysProvider.getWalletKey(walletID);
    if (walletKey == null) {
      throw Exception("Wallet key not found");
    }
    final secretKey = WalletKeyHelper.decryptWalletKey(firstUserKey, walletKey);
    final String mnemonic = await WalletKeyHelper.decrypt(
      secretKey,
      base64Encode(walletModel.mnemonic),
    );
    return mnemonic;
  }

  static Future<ProtonExchangeRate> getExchangeRate(FiatCurrency fiatCurrency,
      {int? time}) async {
    final ProtonExchangeRate exchangeRate = await proton_api.getExchangeRate(
        fiatCurrency: fiatCurrency,
        time: time == null ? null : BigInt.from(time));
    return exchangeRate;
  }

  static int getCurrentTime() {
    return DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  }

  static Future<List<String>> getAccountAddressIDs(
      String serverAccountID) async {
    final List<AddressModel> result =
        await DBHelper.addressDao!.findByServerAccountID(serverAccountID);
    return result.map((e) => e.serverID).toList();
  }

  static Future<void> deleteAddress(String addressID) async {
    await DBHelper.addressDao!.deleteByServerID(addressID);
  }

  // TODO(fix): this function logic looks strange
  static Future<void> autoBindEmailAddresses(String userID) async {
    final int walletCounts = await DBHelper.walletDao!.counts(userID);
    if (walletCounts > 1) {
      return;
    }
    logger.i("Auto binding email address..");
    List<ProtonAddress> protonAddresses = await proton_api.getProtonAddress();
    protonAddresses =
        protonAddresses.where((element) => element.status == 1).toList();
    final ProtonAddress? protonAddress =
        protonAddresses.firstOrNull; // PW-470, can only use primary address
    final WalletModel? walletModel =
        await DBHelper.walletDao!.getFirstPriorityWallet(
      userID,
    );
    if (walletModel != null) {
      final accountModels =
          await DBHelper.accountDao!.findAllByWalletID(walletModel.walletID);
      final AccountModel? accountModel = accountModels.firstOrNull;
      if (accountModel != null && protonAddress != null) {
        await addEmailAddress(
            walletModel.walletID, accountModel.accountID, protonAddress.id);
      }
    }
  }

  static Future<void> addEmailAddress(
    String serverWalletID,
    String serverAccountID,
    String serverAddressID,
  ) async {
    final ApiWalletAccount walletAccount = await proton_api.addEmailAddress(
      walletId: serverWalletID,
      walletAccountId: serverAccountID,
      addressId: serverAddressID,
    );

    for (ApiEmailAddress address in walletAccount.addresses) {
      await walletDataProvider.addEmailAddressToWalletAccount(
        serverWalletID,
        serverAccountID,
        address,
      );
    }
  }

  static Future<Uint8List> decryptBinaryWithUserKeys(
    String encodedEncryptedBinary,
  ) async {
    // get user key
    final firstUserKey = await userManager.getFirstKey();
    final String userPrivateKey = firstUserKey.privateKey;
    final String userPassphrase = firstUserKey.passphrase;

    Uint8List result = Uint8List(0);
    try {
      result = proton_crypto.decryptBinary(
          userPrivateKey, userPassphrase, base64Decode(encodedEncryptedBinary));
    } catch (e) {
      logger.e(e.toString());
    }
    return result;
  }

  static Future<String> decryptWithUserKeys(String encryptedMessage) async {
    final firstUserKey = await userManager.getFirstKey();
    final String userPrivateKey = firstUserKey.privateKey;
    final String userPassphrase = firstUserKey.passphrase;
    String result = "";
    try {
      result = proton_crypto.decrypt(
          userPrivateKey, userPassphrase, encryptedMessage);
    } catch (e) {
      logger.e(e.toString());
    }
    return result;
  }

  static Future<void> fetchWalletsFromServer() async {
    /// lagecy code, use walletDataProvider to fetch data from server
  }

  static Future<void> setLatestEventId(String latestEventId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("latestEventId", latestEventId);
  }

  static Future<String?> getLatestEventId() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("latestEventId");
  }

  static Future<EmailIntegrationBitcoinAddress?> lookupBitcoinAddress(
      String email) async {
    final EmailIntegrationBitcoinAddress emailIntegrationBitcoinAddress =
        await proton_api.lookupBitcoinAddress(email: email);
    // TODO(fix): check signature!
    return emailIntegrationBitcoinAddress;
  }

  static Future<List<AddressKey>> getAddressKeys() async {
    List<ProtonAddress> addresses = await proton_api.getProtonAddress();
    addresses = addresses.where((element) => element.status == 1).toList();

    final firstUserKey = await userManager.getFirstKey();
    final String userPrivateKey = firstUserKey.privateKey;
    final String userPassphrase = firstUserKey.passphrase;

    final List<AddressKey> addressKeys = [];

    for (ProtonAddress address in addresses) {
      for (ProtonAddressKey addressKey in address.keys ?? []) {
        final String addressKeyPrivateKey = addressKey.privateKey ?? "";
        final String addressKeyToken = addressKey.token ?? "";
        try {
          final String addressKeyPassphrase = proton_crypto.decrypt(
            userPrivateKey,
            userPassphrase,
            addressKeyToken,
          );
          addressKeys.add(AddressKey(
            id: address.id,
            privateKey: addressKeyPrivateKey,
            passphrase: addressKeyPassphrase,
          ));
        } catch (e) {
          logger.e(e.toString());
        }
      }
    }

    // TODO(fix): remove this, use old version decrypt method to get addresskeys' passphrase
    addressKeys.add(AddressKey(
      id: "firstUserKey",
      privateKey: userPrivateKey,
      passphrase: userPassphrase,
    ));
    return addressKeys;
  }

  static Future<bool> checkFingerprint(
      WalletModel walletModel, String passphrase) async {
    final String strMnemonic =
        await WalletManager.getMnemonicWithID(walletModel.walletID);
    final String fingerprint =
        await getFingerPrintFromMnemonic(strMnemonic, passphrase: passphrase);
    logger.i("$fingerprint == ${walletModel.fingerprint}");
    return walletModel.fingerprint == fingerprint;
  }

  static Future<void> handleBitcoinAddressRequests(
    FrbAccount account,
    String serverWalletID,
    String serverAccountID,
  ) async {
    final List<ApiWalletBitcoinAddress> walletBitcoinAddresses =
        await proton_api.getWalletBitcoinAddress(
            walletId: serverWalletID,
            walletAccountId: serverAccountID,
            onlyRequest: 1);
    bool hasSyncedBitcoinAddressIndex = false;
    AccountModel? accountModel =
        await DBHelper.accountDao!.findByServerID(serverAccountID);
    for (ApiWalletBitcoinAddress walletBitcoinAddress
        in walletBitcoinAddresses) {
      if (accountModel == null) {
        logger.e("handleBitcoinAddressRequests: accountModel is null");
        continue;
      }
      if (walletBitcoinAddress.bitcoinAddress == null) {
        final WalletModel? walletModel =
            await DBHelper.walletDao!.findByServerID(serverWalletID);
        if (!hasSyncedBitcoinAddressIndex) {
          hasSyncedBitcoinAddressIndex = true;
          if (walletModel != null) {
            await syncBitcoinAddressIndex(
              walletModel,
              accountModel,
            );
          }
        }
        accountModel =
            await DBHelper.accountDao!.findByServerID(serverAccountID);
        if (accountModel == null) {
          logger.e(
              "handleBitcoinAddressRequests: accountModel is null after syncBitcoinAddressIndex()");
          continue;
        }
        // need plus 2 since the lastUsedIndex + 1 is used for manual receive
        final int addressIndex = accountModel.lastUsedIndex + 2;
        final addressInfo = await account.getAddress(index: addressIndex);
        final String address = addressInfo.address;
        final String signature = await getSignature(
          serverAccountID,
          address,
          gpgContextWalletBitcoinAddress,
        );
        logger.i(signature);
        final BitcoinAddress bitcoinAddress = BitcoinAddress(
            bitcoinAddress: address,
            bitcoinAddressSignature: signature,
            bitcoinAddressIndex: BigInt.from(addressIndex));
        await proton_api.updateBitcoinAddress(
            walletId: serverWalletID,
            walletAccountId: serverAccountID,
            walletAccountBitcoinAddressId: walletBitcoinAddress.id,
            bitcoinAddress: bitcoinAddress);
        try {
          await DBHelper.bitcoinAddressDao!.insertOrUpdate(
              serverWalletID: serverWalletID,
              serverAccountID: accountModel.accountID,
              bitcoinAddress: address,
              bitcoinAddressIndex: addressIndex,
              inEmailIntegrationPool: 1,
              used: 0);
        } catch (e) {
          logger.e(e.toString());
        }
        accountModel.lastUsedIndex = accountModel.lastUsedIndex + 2;
        await updateLastUsedIndex(accountModel);
      }
    }
  }

  static Future<void> syncBitcoinAddressIndex(
      WalletModel walletModel, AccountModel accountModel) async {
    /// check if local highest used bitcoin address index is higher than the one store in wallet account
    /// this will happen when some one send bitcoin via qr code
    final int localUsedIndex = await localBitcoinAddressDataProvider
        .getLastUsedIndex(walletModel, accountModel);
    if (localUsedIndex > accountModel.lastUsedIndex) {
      accountModel.lastUsedIndex = localUsedIndex;
      await updateLastUsedIndex(accountModel);
    }
  }

  static Future<void> updateLastUsedIndex(AccountModel accountModel) async {
    /// don't need await this
    walletDataProvider.walletClient.updateWalletAccountLastUsedIndex(
      walletId: accountModel.walletID,
      walletAccountId: accountModel.accountID,
      lastUsedIndex: accountModel.lastUsedIndex,
    );
    await walletDataProvider.insertOrUpdateAccount(
      accountModel.walletID,
      accountModel.label.base64encode(),
      accountModel.scriptType,
      accountModel.derivationPath,
      accountModel.accountID,
      accountModel.fiatCurrency.toFiatCurrency(),
      accountModel.priority,
      accountModel.lastUsedIndex,
      notify: false,
    );
  }

  static Future<void> bitcoinAddressPoolHealthCheck(
    FrbAccount account,
    String serverWalletID,
    String serverAccountID,
  ) async {
    int unFetchedBitcoinAddressCount = 0;
    final List<ApiWalletBitcoinAddress> walletBitcoinAddresses =
        await proton_api.getWalletBitcoinAddress(
            walletId: serverWalletID,
            walletAccountId: serverAccountID,
            onlyRequest: 0);
    final List<String> addressIDs =
        await WalletManager.getAccountAddressIDs(serverAccountID);
    List<AddressKey> addressKeys = await getAddressKeys();
    addressKeys = addressKeys
        .where((addressKey) => addressIDs.contains(addressKey.id))
        .toList();
    for (var walletBitcoinAddress in walletBitcoinAddresses) {
      try {
        final String bitcoinAddress = walletBitcoinAddress.bitcoinAddress ?? "";
        final int addressIndex =
            walletBitcoinAddress.bitcoinAddressIndex?.toInt() ?? -1;
        if (addressIndex >= 0 && bitcoinAddress.isNotEmpty) {
          await DBHelper.bitcoinAddressDao!.insertOrUpdate(
              serverWalletID: serverWalletID,
              serverAccountID: serverAccountID,
              bitcoinAddress: walletBitcoinAddress.bitcoinAddress ?? "",
              bitcoinAddressIndex: addressIndex,
              inEmailIntegrationPool: 1,
              used: walletBitcoinAddress.used);
        }
      } catch (e) {
        logger.e(e.toString());
      }
      if (walletBitcoinAddress.fetched == 0 && walletBitcoinAddress.used == 0) {
        unFetchedBitcoinAddressCount++;
      }
      bool isValidSignature = false;
      if (walletBitcoinAddress.bitcoinAddress != null &&
          walletBitcoinAddress.bitcoinAddressSignature != null) {
        for (AddressKey addressKey in addressKeys) {
          final String armoredPublicKey =
              proton_crypto.getArmoredPublicKey(addressKey.privateKey);
          isValidSignature = await verifySignature(
              armoredPublicKey,
              walletBitcoinAddress.bitcoinAddress!,
              walletBitcoinAddress.bitcoinAddressSignature!,
              gpgContextWalletBitcoinAddress);
          if (isValidSignature) {
            break;
          }
        }
      }
      logger.i("bitcoinAddressSignature valid is $isValidSignature");
    }
    final int addingCount = max(0,
        defaultBitcoinAddressCountForOneEmail - unFetchedBitcoinAddressCount);
    if (walletBitcoinAddresses.isEmpty) {
      final int _ = await DBHelper.bitcoinAddressDao!.getUnusedPoolCount(
        serverWalletID,
        serverAccountID,
      );
      // addingCount = min(addingCount,
      //     defaultBitcoinAddressCountForOneEmail - localUnusedPoolCount);
      logger.i(
          "update with local pool count\nwalletBitcoinAddresses.length = ${walletBitcoinAddresses.length}, addingCount = $addingCount, unFetchedBitcoinAddressCount=$unFetchedBitcoinAddressCount");
    }
    logger.i(
        "walletBitcoinAddresses.length = ${walletBitcoinAddresses.length}, addingCount = $addingCount, unFetchedBitcoinAddressCount=$unFetchedBitcoinAddressCount");
    if (addingCount > 0) {
      final WalletModel? walletModel =
          await DBHelper.walletDao!.findByServerID(serverWalletID);
      AccountModel? accountModel =
          await DBHelper.accountDao!.findByServerID(serverAccountID);
      if (walletModel != null && accountModel != null) {
        await syncBitcoinAddressIndex(
          walletModel,
          accountModel,
        );
      }

      /// get accountModel again since last used index may changed after syncBitcoinAddressIndex();
      accountModel = await DBHelper.accountDao!.findByServerID(serverAccountID);
      if (accountModel == null) {
        return;
      }
      for (int offset = 0; offset < addingCount; offset++) {
        final int addressIndex = accountModel.lastUsedIndex +
            offset +
            2; // need plus 2 since the lastUsedIndex + 1 is used for manual receive
        logger.i(
            "Adding bitcoin address index ($addressIndex), serverAccountID = $serverAccountID");

        final addressInfo = await account.getAddress(index: addressIndex);
        final String address = addressInfo.address;
        final String signature = await getSignature(
          serverAccountID,
          address,
          gpgContextWalletBitcoinAddress,
        );
        final BitcoinAddress bitcoinAddress = BitcoinAddress(
            bitcoinAddress: address,
            bitcoinAddressSignature: signature,
            bitcoinAddressIndex: BigInt.from(addressInfo.index));
        await proton_api.addBitcoinAddresses(
            walletId: serverWalletID,
            walletAccountId: serverAccountID,
            bitcoinAddresses: [bitcoinAddress]);
        try {
          await DBHelper.bitcoinAddressDao!.insertOrUpdate(
              serverWalletID: serverWalletID,
              serverAccountID: serverAccountID,
              bitcoinAddress: address,
              bitcoinAddressIndex: addressIndex,
              inEmailIntegrationPool: 1,
              used: 0);
        } catch (e) {
          logger.e(e.toString());
        }
      }
      if (addingCount > 0) {
        accountModel.lastUsedIndex =
            accountModel.lastUsedIndex + addingCount + 1;
        await updateLastUsedIndex(accountModel);
      }
    }
  }

  static Future<String> getSignature(
    String serverAccountID,
    String bitcoinAddress,
    String gpgContext,
  ) async {
    final addressIDs =
        await WalletManager.getAccountAddressIDs(serverAccountID);
    List<AddressKey> addressKeys = await getAddressKeys();
    addressKeys = addressKeys
        .where((addressKey) => addressIDs.contains(addressKey.id))
        .toList();

    final List<String> signatures = [];
    for (AddressKey addressKey in addressKeys) {
      signatures.add(proton_crypto.getSignatureWithContext(
          addressKey.privateKey,
          addressKey.passphrase,
          bitcoinAddress,
          gpgContext));
    }
    return signatures.isNotEmpty
        ? signatures[0]
        : "-----BEGIN PGP SIGNATURE-----*-----END PGP SIGNATURE-----";
    // return signatures.join("\n"); // `TODO`:: add back after check with backend
  }

  static Future<bool> verifySignature(String publicAddressKey, String message,
      String signature, String gpgContext) async {
    return proton_crypto.verifySignatureWithContext(
        publicAddressKey, message, signature, gpgContext);
  }

  static String getEmailFromWalletTransaction(
    String jsonString, {
    List<String> selfEmailAddresses = const [],
  }) {
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final List<String> emails = [];
      for (var item in jsonList) {
        emails.add(item.values);
      }
      return emails.join(", ");
    } catch (e) {
      try {
        final jsonList = jsonDecode(jsonString) as Map<String, dynamic>;
        final List<String> emails = [];
        final List<String> keys = [];
        for (MapEntry<String, dynamic> keyValues in jsonList.entries) {
          // bitcoinAddress as key, emailAddress as value
          keys.add(keyValues.key.toLowerCase());
          if (selfEmailAddresses.contains(keyValues.value)) {
            continue;
          }
          if (keyValues.value.isNotEmpty) {
            emails.add(keyValues.value);
          }
        }
        if (keys.contains("email") && keys.contains("name")) {
          return emails.join(" - ");
        }
        return emails.join(", ");
      } catch (e) {
        return jsonString;
      }
    }
  }

  static String getBitcoinAddressFromWalletTransaction(String jsonString,
      {List<String> selfEmailAddresses = const []}) {
    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList[0].keys.first;
    } catch (e) {
      try {
        final jsonList = jsonDecode(jsonString) as Map<String, dynamic>;
        for (MapEntry<String, dynamic> keyValues in jsonList.entries) {
          // bitcoinAddress as key, emailAddress as value
          if (selfEmailAddresses.contains(keyValues.value)) {
            continue;
          }
          return keyValues.key;
        }
        return "";
      } catch (e) {
        return jsonString;
      }
    }
  }

  static Future<TransactionDetailFromBlockChain?>
      getTransactionDetailsFromBlockStream(String txid) async {
    final String baseUrl = "${appConfig.esploraApiUrl}api";
    try {
      final response = await http.get(Uri.parse('$baseUrl/tx/$txid'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final TransactionDetailFromBlockChain transactionDetailFromBlockChain =
            TransactionDetailFromBlockChain(
                txid: txid,
                feeInSATS: data['fee'],
                blockHeight: data['status']['block_height'] ?? 0,
                timestamp: data['status']['block_time'] ?? 0);
        final List<dynamic> recipientMapList = data['vout']
            .map((output) => {
                  'address': output['scriptpubkey_address'],
                  'value': output['value']
                })
            .toList();
        for (var recipientMap in recipientMapList) {
          transactionDetailFromBlockChain.addRecipient(Recipient(
              bitcoinAddress: recipientMap["address"],
              amountInSATS: recipientMap["value"]));
        }
        return transactionDetailFromBlockChain;
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return null;
  }

  static Future<bool> isMineBitcoinAddress(
    FrbAccount account,
    String bitcoinAddress,
  ) async {
    final network = appConfig.coinType.network;
    return account.isMine(
        address: FrbAddress(address: bitcoinAddress, network: network));
  }

  static Future<FiatCurrency> getDefaultAccountFiatCurrency(
      WalletModel? walletModel) async {
    if (walletModel != null) {
      final AccountModel? accountModel = await DBHelper.accountDao
          ?.findDefaultAccountByWalletID(walletModel.walletID);
      if (accountModel != null) {
        return getAccountFiatCurrency(accountModel);
      }
    }
    return defaultFiatCurrency;
  }

  static FiatCurrency getAccountFiatCurrency(AccountModel? accountModel) {
    if (accountModel != null) {
      return CommonHelper.getFiatCurrencyByName(
          accountModel.fiatCurrency.toUpperCase());
    }
    return defaultFiatCurrency;
  }

  /// ################################################################

  /// trying to get wallet key from secrue store and decrypt it use userkey
  // TODO(fix): remove the static
  static Future<SecretKey> getWalletKey(String serverWalletID) async {
    final firstUserKey = await userManager.getFirstKey();
    final walletKey = await walletKeysProvider.getWalletKey(serverWalletID);
    if (walletKey == null) {
      throw Exception("Wallet key not found");
    }
    final secretKey = WalletKeyHelper.decryptWalletKey(firstUserKey, walletKey);
    return secretKey;
  }

  // TODO(fix): remove the static
  static Future<void> setWalletKey(List<ApiWalletKey> apiWalletKey) async {
    await walletKeysProvider.saveApiWalletKeys(apiWalletKey);
  }

  /// Mark: base functions

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init() async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> login(String userID) async {
    // TODO(fix): implement login
    throw UnimplementedError();
  }
}
