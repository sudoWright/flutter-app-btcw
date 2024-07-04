import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wallet/constants/script_type.dart';
import 'package:wallet/models/account.model.dart';
import 'package:wallet/models/database/app.database.dart';

Future<void> main() async {
  AppDatabase appDatabase = AppDatabase();
  DateTime now = DateTime.now();

  setUpAll(() async {
    databaseFactory = databaseFactoryFfi;
    await appDatabase.init(await AppDatabase.getInMemoryDatabase());
    await appDatabase.buildDatabase();
  });

  group('AccountDao', () {
    test('Insert case 1', () async {
      // Insert the data
      int id = await appDatabase.accountDao.insert(AccountModel(
          id: -1,
          walletID: "server_walletid_1",
          derivationPath: "m/84'/1'/0'/0",
          label: Uint8List(0),
          fiatCurrency: "USD",
          scriptType: ScriptTypeInfo.legacy.index,
          createTime: now.millisecondsSinceEpoch ~/ 1000,
          modifyTime: now.millisecondsSinceEpoch ~/ 1000,
          accountID: ""));
      expect(id, 1);
      id = await appDatabase.accountDao.insert(AccountModel(
          id: -1,
          walletID: "server_walletid_12",
          derivationPath: "m/84'/1'/0'/0",
          label: Uint8List(0),
          fiatCurrency: "USD",
          scriptType: ScriptTypeInfo.nativeSegWit.index,
          createTime: now.millisecondsSinceEpoch ~/ 1000,
          modifyTime: now.millisecondsSinceEpoch ~/ 1000,
          accountID: ""));
      expect(id, 2);

      id = await appDatabase.accountDao.insert(AccountModel(
          id: -1,
          walletID: "server_walletid_12",
          derivationPath: "m/84'/1'/168'/0",
          label: Uint8List(1),
          fiatCurrency: "CHF",
          scriptType: ScriptTypeInfo.nestedSegWit.index,
          createTime: now.millisecondsSinceEpoch ~/ 1000,
          modifyTime: now.millisecondsSinceEpoch ~/ 1000,
          accountID: ""));
      expect(id, 3);

      id = await appDatabase.accountDao.insert(AccountModel(
          id: -1,
          walletID: "server_walletid_12",
          derivationPath: "m/84'/1'/168'/2",
          label: Uint8List(2),
          fiatCurrency: "CHF",
          scriptType: ScriptTypeInfo.nestedSegWit.index,
          createTime: now.millisecondsSinceEpoch ~/ 1000,
          modifyTime: now.millisecondsSinceEpoch ~/ 1000,
          accountID: ""));
      expect(id, 4);

      // this should fail
      id = await appDatabase.accountDao.insert(AccountModel(
          id: -1,
          walletID: "server_walletid_12",
          derivationPath: "m/84'/1'/168'/2",
          label: Uint8List(3),
          fiatCurrency: "USD",
          scriptType: ScriptTypeInfo.nestedSegWit.index,
          createTime: now.millisecondsSinceEpoch ~/ 1000,
          modifyTime: now.millisecondsSinceEpoch ~/ 1000,
          accountID: ""));
      expect(id, 5);
    });

    test('getAccountCount case 1', () async {
      int count =
          await appDatabase.accountDao.getAccountCount("server_walletid_12");
      expect(count, 3);
      count = await appDatabase.accountDao.getAccountCount("server_walletid_1");
      expect(count, 1);
      count =
          await appDatabase.accountDao.getAccountCount("server_walletid_11");
      expect(count, 0);
    });

    test('findAll case 1', () async {
      var walletID = "server_walletid_12";
      var results = await appDatabase.accountDao.findAllByWalletID(walletID);
      // Verify that the data was inserted and retrieved correctly
      expect(results.length, 3);
      expect(results[0].id, 2);
      expect(results[0].walletID, walletID);
      expect(results[0].derivationPath, "m/84'/1'/0'/0");
      expect(results[0].fiatCurrency, "USD");
      expect(results[0].scriptType, ScriptTypeInfo.nativeSegWit.index);
      expect(results[0].createTime, now.millisecondsSinceEpoch ~/ 1000);
      expect(results[0].modifyTime, now.millisecondsSinceEpoch ~/ 1000);

      expect(results[1].id, 3);
      expect(results[1].walletID, walletID);
      expect(results[1].derivationPath, "m/84'/1'/168'/0");
      expect(results[1].fiatCurrency, "CHF");
      expect(results[1].scriptType, ScriptTypeInfo.nestedSegWit.index);
      expect(results[1].createTime, now.millisecondsSinceEpoch ~/ 1000);
      expect(results[1].modifyTime, now.millisecondsSinceEpoch ~/ 1000);

      expect(results[2].id, 5);
      expect(results[2].walletID, walletID);
      expect(results[2].derivationPath, "m/84'/1'/168'/2");
      expect(results[2].label, Uint8List(3));
      expect(results[2].fiatCurrency, "USD");
      expect(results[2].scriptType, ScriptTypeInfo.nestedSegWit.index);
      expect(results[2].createTime, now.millisecondsSinceEpoch ~/ 1000);
      expect(results[2].modifyTime, now.millisecondsSinceEpoch ~/ 1000);

      results =
          await appDatabase.accountDao.findAllByWalletID("server_walletid_1");
      expect(results.length, 1);
      expect(results[0].id, 1);
      expect(results[0].walletID, "server_walletid_1");
      expect(results[0].label, Uint8List(0));
      expect(results[0].derivationPath, "m/84'/1'/0'/0");
      expect(results[0].scriptType, ScriptTypeInfo.legacy.index);
      expect(results[0].fiatCurrency, "USD");
      expect(results[0].createTime, now.millisecondsSinceEpoch ~/ 1000);
      expect(results[0].modifyTime, now.millisecondsSinceEpoch ~/ 1000);
    });

    test('findByID case 1', () async {
      // findByID
      AccountModel accountModel = await appDatabase.accountDao.findById(3);
      expect(accountModel.id, 3);
      expect(accountModel.walletID, "server_walletid_12");
      expect(accountModel.derivationPath, "m/84'/1'/168'/0");
      expect(accountModel.fiatCurrency, "CHF");
      expect(accountModel.scriptType, ScriptTypeInfo.nestedSegWit.index);
      expect(accountModel.createTime, now.millisecondsSinceEpoch ~/ 1000);
      expect(accountModel.modifyTime, now.millisecondsSinceEpoch ~/ 1000);
    });

    test('findAllByWalletID case 1', () async {
      // findByID
      List results =
          await appDatabase.accountDao.findAllByWalletID("server_walletid_12");
      expect(results.length, 3);

      results =
          await appDatabase.accountDao.findAllByWalletID("server_walletid_1");
      expect(results.length, 1);

      results =
          await appDatabase.accountDao.findAllByWalletID("server_walletid_11");
      expect(results.length, 0);
    });

    test('delete case 1', () async {
      // Delete record
      await appDatabase.accountDao.delete(2);
      var walletID = "server_walletid_12";

      // Verify new result after delete
      List results = await appDatabase.accountDao.findAllByWalletID(walletID);
      // Verify that the data was inserted and retrieved correctly
      expect(results[0].id, 3);
      expect(results[0].walletID, walletID);
      expect(results[0].derivationPath, "m/84'/1'/168'/0");
      expect(results[0].fiatCurrency, "CHF");
      expect(results[0].scriptType, ScriptTypeInfo.nestedSegWit.index);
      expect(results[0].createTime, now.millisecondsSinceEpoch ~/ 1000);
      expect(results[0].modifyTime, now.millisecondsSinceEpoch ~/ 1000);

      expect(results[1].id, 5);
      expect(results[1].walletID, walletID);
      expect(results[1].derivationPath, "m/84'/1'/168'/2");
      expect(results[1].label, Uint8List(3));
      expect(results[1].fiatCurrency, "USD");
      expect(results[1].scriptType, ScriptTypeInfo.nestedSegWit.index);
      expect(results[1].createTime, now.millisecondsSinceEpoch ~/ 1000);
      expect(results[1].modifyTime, now.millisecondsSinceEpoch ~/ 1000);
    });

    test('update case 1', () async {
      await appDatabase.accountDao.update(AccountModel(
          id: 3,
          walletID: "server_id_112",
          derivationPath: "m/84'/1'/12'/0",
          label: Uint8List(0),
          fiatCurrency: "USD",
          scriptType: ScriptTypeInfo.taproot.index,
          createTime: now.millisecondsSinceEpoch ~/ 1000 + 1234567,
          modifyTime: now.millisecondsSinceEpoch ~/ 1000 + 55688,
          accountID: ""));
      AccountModel accountModel = await appDatabase.accountDao.findById(3);
      expect(accountModel.id, 3);
      expect(accountModel.walletID, "server_id_112");
      expect(accountModel.derivationPath, "m/84'/1'/12'/0");
      expect(accountModel.scriptType, ScriptTypeInfo.taproot.index);
      expect(accountModel.createTime,
          now.millisecondsSinceEpoch ~/ 1000 + 1234567);
      expect(
          accountModel.modifyTime, now.millisecondsSinceEpoch ~/ 1000 + 55688);
    });
  });
}
