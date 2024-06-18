import 'dart:typed_data';

class TransactionModel {
  int? id;
  int walletID;
  Uint8List label;
  Uint8List externalTransactionID;
  int createTime;
  int modifyTime;
  Uint8List hashedTransactionID;
  String transactionID;
  String transactionTime;
  String exchangeRateID;
  String serverWalletID;
  String serverAccountID;
  String serverID;
  String? sender;
  String? tolist;
  String? subject;
  String? body;

  TransactionModel({
    required this.id,
    required this.walletID,
    required this.label,
    required this.externalTransactionID,
    required this.createTime,
    required this.modifyTime,
    required this.hashedTransactionID,
    required this.transactionID,
    required this.transactionTime,
    required this.exchangeRateID,
    required this.serverWalletID,
    required this.serverAccountID,
    required this.serverID,
    required this.sender,
    required this.tolist,
    required this.subject,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'walletID': walletID,
      'label': label,
      'externalTransactionID': externalTransactionID,
      'createTime': createTime,
      'modifyTime': modifyTime,
      'hashedTransactionID': hashedTransactionID,
      'transactionID': transactionID,
      'transactionTime': transactionTime,
      'exchangeRateID': exchangeRateID,
      'serverWalletID': serverWalletID,
      'serverAccountID': serverAccountID,
      'serverID': serverID,
      'sender': sender,
      'tolist': tolist,
      'subject': subject,
      'body': body,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      walletID: map['walletID'],
      label: map['label'],
      externalTransactionID: map['externalTransactionID'],
      createTime: map['createTime'],
      modifyTime: map['modifyTime'],
      hashedTransactionID: map['hashedTransactionID'],
      transactionID: map['transactionID'],
      transactionTime: map['transactionTime'],
      exchangeRateID: map['exchangeRateID'],
      serverWalletID: map['serverWalletID'],
      serverAccountID: map['serverAccountID'],
      serverID: map['serverID'],
      sender: map['sender'],
      tolist: map['tolist'],
      subject: map['subject'],
      body: map['body'],
    );
  }
}
