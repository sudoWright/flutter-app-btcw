import 'package:wallet/helper/walletkey_helper.dart';
import 'package:wallet/managers/providers/data.provider.manager.dart';
import 'package:wallet/managers/providers/wallet.keys.provider.dart';
import 'package:wallet/models/account.dao.impl.dart';
import 'package:wallet/models/account.model.dart';
import 'package:wallet/models/wallet.dao.impl.dart';
import 'package:wallet/models/wallet.model.dart';

class WalletNameProvider extends DataProvider {
  final WalletKeysProvider walletKeysProvider;
  final AccountDao accountDao;
  final WalletDao walletDao;

  WalletNameProvider(
    this.walletKeysProvider,
    this.accountDao,
    this.walletDao,
  );

  Future<String> getAccountLabelWithID(String accountID) async {
    final AccountModel accountModel = await accountDao.findByServerID(
      accountID,
    );
    final secretKey = await walletKeysProvider.getWalletSecretKey(
      accountModel.walletID,
    );
    await accountModel.decrypt(secretKey);
    return accountModel.labelDecrypt;
  }

  Future<String> getNameWithID(String walletID) async {
    String encryptedName = "";
    final WalletModel walletRecord = await walletDao.findByServerID(
      walletID,
    );
    encryptedName = walletRecord.name;
    final secretKey = await walletKeysProvider.getWalletSecretKey(
      walletID,
    );
    final name = await WalletKeyHelper.decrypt(secretKey, encryptedName);
    return name;
  }

  @override
  Future<void> clear() async {}

  @override
  Future<void> reload() async {}
}
