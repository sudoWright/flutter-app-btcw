import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';
import 'package:wallet/models/database/base.dao.dart';
import 'package:wallet/models/database/transaction.info.database.dart';
import 'package:wallet/models/transaction.info.model.dart';

abstract class TransactionInfoDao extends TransactionInfoDatabase
    implements BaseDao {
  TransactionInfoDao(super.db, super.tableName);

  Future<void> insertOrUpdate({
    required Uint8List externalTransactionID,
    required int amountInSATS,
    required int feeInSATS,
    required int isSend,
    required int transactionTime,
    required int feeMode,
    required String serverWalletID,
    required String serverAccountID,
    required String toEmail,
    required String toBitcoinAddress,
  });

  Future<TransactionInfoModel?> find(Uint8List externalTransactionID,
      String serverWalletID, String serverAccountID, String toBitcoinAddress);

  Future<List<TransactionInfoModel>> findAllByServerAccountID(
    String serverAccountID,
  );

  Future<List> findAll();
}

class TransactionInfoDaoImpl extends TransactionInfoDao {
  TransactionInfoDaoImpl(Database db) : super(db, 'transactionInfo');

  @override
  Future<void> delete(int id) async {
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List> findAll() async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(
        maps.length, (index) => TransactionInfoModel.fromMap(maps[index]));
  }

  @override
  Future<int> insert(item) async {
    int id = 0;
    if (item is TransactionInfoModel) {
      id = await db.insert(tableName, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else if (item is Map<String, dynamic>) {
      id = await db.insert(tableName, item,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return id;
  }

  @override
  Future<void> update(item) async {
    if (item is TransactionInfoModel) {
      await db.update(tableName, item.toMap(),
          where: 'id = ?', whereArgs: [item.id]);
    } else if (item is Map<String, dynamic>) {
      await db
          .update(tableName, item, where: 'id = ?', whereArgs: [item["id"]]);
    }
  }

  @override
  Future<void> insertOrUpdate({
    required Uint8List externalTransactionID,
    required int amountInSATS,
    required int feeInSATS,
    required int isSend,
    required int transactionTime,
    required int feeMode,
    required String serverWalletID,
    required String serverAccountID,
    required String toEmail,
    required String toBitcoinAddress,
  }) async {
    final TransactionInfoModel? transactionInfoModel = await find(
        externalTransactionID,
        serverWalletID,
        serverAccountID,
        toBitcoinAddress);
    if (transactionInfoModel != null) {
      await update({
        "id": transactionInfoModel.id,
        "externalTransactionID": externalTransactionID,
        "amountInSATS": amountInSATS,
        "feeInSATS": feeInSATS,
        "isSend": isSend,
        "transactionTime": transactionTime,
        "feeMode": feeMode,
        "serverWalletID": serverWalletID,
        "serverAccountID": serverAccountID,
        "toEmail": toEmail,
        "toBitcoinAddress": toBitcoinAddress,
      });
    } else {
      await insert({
        "externalTransactionID": externalTransactionID,
        "amountInSATS": amountInSATS,
        "feeInSATS": feeInSATS,
        "isSend": isSend,
        "transactionTime": transactionTime,
        "feeMode": feeMode,
        "serverWalletID": serverWalletID,
        "serverAccountID": serverAccountID,
        "toEmail": toEmail,
        "toBitcoinAddress": toBitcoinAddress,
      });
    }
  }

  @override
  Future findById(int id) {
    throw UnimplementedError(); // no need for this function
  }

  @override
  Future<TransactionInfoModel?> find(
      Uint8List externalTransactionID,
      String serverWalletID,
      String serverAccountID,
      String toBitcoinAddress) async {
    List<Map<String, dynamic>> maps = await db.query(tableName,
        where:
            'externalTransactionID = ? and serverWalletID = ? and serverAccountID = ? and toBitcoinAddress = ?',
        whereArgs: [
          externalTransactionID,
          serverWalletID,
          serverAccountID,
          toBitcoinAddress
        ]);
    if (maps.isNotEmpty) {
      return TransactionInfoModel.fromMap(maps.first);
    }

    // TODO(fix): deprecated it for old version
    maps = await db.query(tableName,
        where:
            'externalTransactionID = ? and serverWalletID = ? and serverAccountID = ?',
        whereArgs: [externalTransactionID, serverWalletID, serverAccountID]);
    if (maps.isNotEmpty) {
      return TransactionInfoModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<TransactionInfoModel>> findAllByServerAccountID(
      String serverAccountID) async {
    final List<TransactionInfoModel> results = [];
    final List<Map<String, dynamic>> maps = await db.query(tableName,
        where: 'serverAccountID = ?', whereArgs: [serverAccountID]);
    if (maps.isNotEmpty) {
      for (var map in maps) {
        results.add(TransactionInfoModel.fromMap(map));
      }
    }
    return results;
  }

  @override
  Future<void> deleteByServerID(String id) {
    throw UnimplementedError();
  }

  @override
  Future findByServerID(String serverID) {
    throw UnimplementedError();
  }
}
