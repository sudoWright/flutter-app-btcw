import 'dart:async';
import 'dart:convert';
import 'package:wallet/managers/providers/data.provider.manager.dart';
import 'package:wallet/models/account.dao.impl.dart';
import 'package:wallet/models/account.model.dart';
import 'package:wallet/models/exchangerate.dao.impl.dart';
import 'package:wallet/models/exchangerate.model.dart';
import 'package:wallet/models/transaction.dao.impl.dart';
import 'package:wallet/models/transaction.model.dart';
import 'package:wallet/models/wallet.dao.impl.dart';
import 'package:wallet/models/wallet.model.dart';
import 'package:wallet/rust/api/api_service/wallet_client.dart';
import 'package:wallet/rust/proton_api/wallet.dart';

class ServerTransactionData {
  final AccountModel accountModel;
  List<TransactionModel> transactions = [];

  ServerTransactionData({
    required this.accountModel,
    required this.transactions,
  });
}

class ServerTransactionDataProvider extends DataProvider {
  StreamController<DataUpdated> dataUpdateController =
      StreamController<DataUpdated>.broadcast();

  ///
  final WalletClient walletClient;
  final WalletDao walletDao;
  final AccountDao accountDao;
  final ExchangeRateDao exchangeRateDao;
  final TransactionDao transactionDao;
  final String userID;

  ServerTransactionDataProvider(
    this.walletClient,
    this.walletDao,
    this.accountDao,
    this.exchangeRateDao,
    this.transactionDao,
    this.userID,
  );

  ///
  List<ServerTransactionData> serverTransactionDataList = [];
  bool initialized = false;

  Future<List<ServerTransactionData>> _getFromDB() async {
    List<ServerTransactionData> transactionDataList = [];
    var wallets = await walletDao.findAllByUserID(userID);
    if (wallets.isNotEmpty) {
      for (WalletModel walletModel in wallets) {
        var accounts = await accountDao.findAllByWalletID(walletModel.walletID);
        for (AccountModel accountModel in accounts) {
          var transactions = await transactionDao.findAllByServerAccountID(
            accountModel.accountID,
          );
          var serverTransactionData = ServerTransactionData(
            accountModel: accountModel,
            transactions: transactions,
          );
          transactionDataList.add(serverTransactionData);
        }
      }
      return transactionDataList;
    }
    return [];
  }

  Future<List<TransactionModel>> _getFromDBByAccount(String accountID) async {
    var transactions = await transactionDao.findAllByServerAccountID(
      accountID,
    );

    return transactions;
  }

  Future<ServerTransactionData> getServerTransactionDataByWalletAccount(
    WalletModel walletModel,
    AccountModel accountModel,
  ) async {
    List<ServerTransactionData> serverTransactionsData =
        await getServerTransactionData();
    for (ServerTransactionData serverTransactionData
        in serverTransactionsData) {
      if (serverTransactionData.accountModel.accountID ==
          accountModel.accountID) {
        return serverTransactionData;
      }
    }
    // no server transaction found for this account, return empty transactions array
    return ServerTransactionData(accountModel: accountModel, transactions: []);
  }

  Future<List<TransactionModel>> getTransByAccountID(
    String walletID,
    String accountID,
  ) async {
    // check cache first
    List<ServerTransactionData> transactionDataList =
        await getServerTransactionData();
    for (ServerTransactionData serverTransactionData in transactionDataList) {
      if (serverTransactionData.accountModel.walletID == walletID &&
          serverTransactionData.accountModel.accountID == accountID) {
        return serverTransactionData.transactions;
      }
    }
    // fetch from server
    await fetchTransactions(walletID, accountID);

    // fetch from db
    var dbTrans = await _getFromDBByAccount(accountID);
    if (dbTrans.isNotEmpty) {
      return dbTrans;
    }
    return [];
  }

  Future<List<ServerTransactionData>> getServerTransactionData() async {
    if (initialized) {
      return serverTransactionDataList;
    }
    // fetch from server
    var wallets = await walletDao.findAllByUserID(userID);
    for (WalletModel walletModel in wallets) {
      await fetchTransactions(
        walletModel.walletID,
        null,
        isInitializeProcess: true,
      );
    }
    serverTransactionDataList = await _getFromDB();
    initialized = true;
    return serverTransactionDataList;
  }

  Future<void> fetchTransactions(
    String walletID,
    String? accountID, {
    bool isInitializeProcess = false,
  }) async {
    var walletTransactions = await walletClient.getWalletTransactions(
      walletId: walletID,
      walletAccountId: accountID,
    );

    for (WalletTransaction walletTransaction in walletTransactions) {
      await handleWalletTransaction(
        walletTransaction,
        isInitializeProcess: isInitializeProcess,
      );
    }
  }

  Future<void> handleWalletTransaction(
    WalletTransaction walletTransaction, {
    bool notifyDataUpdate = false,
    bool isInitializeProcess = false,
  }) async {
    DateTime now = DateTime.now();

    String exchangeRateID = "";
    if (walletTransaction.exchangeRate != null) {
      exchangeRateID = walletTransaction.exchangeRate!.id;
      ExchangeRateModel exchangeRateModel = ExchangeRateModel(
        id: null,
        serverID: walletTransaction.exchangeRate!.id,
        bitcoinUnit:
            walletTransaction.exchangeRate!.bitcoinUnit.name.toUpperCase(),
        fiatCurrency:
            walletTransaction.exchangeRate!.fiatCurrency.name.toUpperCase(),
        sign: "",
        // TODO:: add sign once apiClient update for it
        exchangeRateTime: walletTransaction.exchangeRate!.exchangeRateTime,
        exchangeRate: walletTransaction.exchangeRate!.exchangeRate,
        cents: walletTransaction.exchangeRate!.cents,
      );
      await exchangeRateDao.insert(exchangeRateModel);
    }

    TransactionModel transactionModel = TransactionModel(
        id: -1,
        type:
            walletTransaction.type?.index ?? TransactionType.unsupported.index,
        label: utf8.encode(walletTransaction.label ?? ""),
        externalTransactionID: utf8.encode(""),

        /// deprecated
        createTime: now.millisecondsSinceEpoch ~/ 1000,
        modifyTime: now.millisecondsSinceEpoch ~/ 1000,
        hashedTransactionID:
            utf8.encode(walletTransaction.hashedTransactionId ?? ""),
        transactionID: walletTransaction.transactionId,
        serverID: walletTransaction.id,
        transactionTime: walletTransaction.transactionTime,
        exchangeRateID: exchangeRateID,
        serverWalletID: walletTransaction.walletId,
        serverAccountID: walletTransaction.walletAccountId!,
        sender: walletTransaction.sender,
        tolist: walletTransaction.tolist,
        subject: walletTransaction.subject,
        body: walletTransaction.body);
    await insertOrUpdate(
      transactionModel,
      notifyDataUpdate: notifyDataUpdate,
      isInitializeProcess: isInitializeProcess,
    );
  }

  Future<void> insertOrUpdate(
    TransactionModel transactionModel, {
    bool notifyDataUpdate = false,
    bool isInitializeProcess = false,
    UpdateType? updateType,
  }) async {
    TransactionModel? transactionModelInDB =
        await transactionDao.findByServerID(transactionModel.serverID);
    bool transactionModelExists = transactionModelInDB != null;
    if (transactionModelInDB != null) {
      transactionModel.id = transactionModelInDB
          .id; // need to update id since the update function is based on auto increase id
    }
    await transactionDao.insertOrUpdate(transactionModel);

    /// refresh cache
    /// TODO:: improve performance
    if (isInitializeProcess == false) {
      /// only need to update cached serverTransactionDataList after initialized
      serverTransactionDataList = await _getFromDB();
    }
    if (notifyDataUpdate) {
      if (updateType != null) {
        dataUpdateController.add(DataUpdated(updateType));
      } else {
        if (transactionModelExists) {
          dataUpdateController.add(DataUpdated(UpdateType.updated));
        } else {
          dataUpdateController.add(DataUpdated(UpdateType.inserted));
        }
      }
    }
  }

  Future<void> reloadAccountTransactions(
    String walletID,
    String accountID,
  ) async {
    // fetch from server
    await fetchTransactions(
      walletID,
      accountID,
      isInitializeProcess: true,
    );
    serverTransactionDataList = await _getFromDB();
  }

  @override
  Future<void> clear() async {
    dataUpdateController.close();
  }
}
