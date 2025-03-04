import 'dart:async';
import 'dart:convert';

import 'package:wallet/managers/providers/data.provider.manager.dart';
import 'package:wallet/managers/providers/models/wallet.passphrase.dart';
import 'package:wallet/managers/secure.storage/secure.storage.manager.dart';

class WalletPassphraseProvider extends DataProvider {
  /// secure storage
  final SecureStorageManager storage;
  final String key = "proton_wallet_p_provider_key";

  /// memory caches
  List<WalletPassphrase>? walletPassphrases;

  /// stream
  StreamController<DataUpdated> dataUpdateController =
      StreamController<DataUpdated>();

  WalletPassphraseProvider(this.storage);

  Future<String?> getPassphrase(String walletID) async {
    final passphrases = await _getWalletPassphrases();
    final pwd = passphrases
        .where((passphrase) => passphrase.walletID == walletID)
        .toList()
        .firstOrNull;
    return pwd?.passphrase;
  }

  /// save passphrase to secure storage
  Future<void> saveWalletPassphrase(WalletPassphrase walletPassphrase) async {
    final String? passphrase = await getPassphrase(walletPassphrase.walletID);
    if (passphrase == null) {
      final List<WalletPassphrase> passphrases = await _getWalletPassphrases();
      passphrases.add(walletPassphrase);
      final List<Map<String, dynamic>> jsonList =
          WalletPassphrase.toJsonList(passphrases);
      await storage.set(key, json.encode(jsonList));
      walletPassphrases = await _getFromSecureStorage();
      dataUpdateController.add(DataUpdated("new wallet passphrase added!"));
    }
  }

  /// get passphrase from secure storage
  Future<List<WalletPassphrase>> _getFromSecureStorage() async {
    List<WalletPassphrase> passphrases = [];
    final json = await storage.get(key);
    if (json.isNotEmpty) {
      passphrases = await WalletPassphrase.loadJsonString(json);
    }
    return passphrases;
  }

  Future<List<WalletPassphrase>> _getWalletPassphrases() async {
    /// return directly if cache exists
    if (walletPassphrases != null) {
      return walletPassphrases!;
    }

    /// update cache from secure storage
    walletPassphrases = await _getFromSecureStorage();
    return walletPassphrases ?? [];
  }

  @override
  Future<void> clear() async {
    walletPassphrases?.clear();
    dataUpdateController.close();
  }

  @override
  Future<void> reload() async {}
}
