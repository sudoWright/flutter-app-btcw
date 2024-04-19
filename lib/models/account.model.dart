import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:wallet/helper/dbhelper.dart';

import 'package:wallet/helper/wallet_manager.dart';
import 'package:wallet/helper/walletkey_helper.dart';
import 'package:wallet/models/wallet.model.dart';

class AccountModel {
  int? id;
  int walletID;
  String derivationPath;
  Uint8List label;
  int scriptType;
  int createTime;
  int modifyTime;

  String labelDecrypt = "Default Account";
  String serverAccountID;
  double balance = 0;

  AccountModel({
    required this.id,
    required this.walletID,
    required this.derivationPath,
    required this.label,
    required this.scriptType,
    required this.createTime,
    required this.modifyTime,
    required this.serverAccountID,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'walletID': walletID,
      'derivationPath': derivationPath,
      'label': label,
      'scriptType': scriptType,
      'createTime': createTime,
      'modifyTime': modifyTime,
      'serverAccountID': serverAccountID,
    };
  }

  Future<void> decrypt() async {
    for (int i =0; i< 5; i++) {
      try {
        WalletModel walletModel = await DBHelper.walletDao!.findById(walletID);
        SecretKey? secretKey = await WalletManager.getWalletKey(
            walletModel.serverWalletID);
        String value = base64Encode(label);
        if (value != "" && secretKey != null) {
          labelDecrypt = await WalletKeyHelper.decrypt(secretKey, value);
        }
        break;
      } catch (e) {
        await Future.delayed(const Duration(milliseconds: 300));
        labelDecrypt = e.toString();
      }
    }
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    AccountModel accountModel = AccountModel(
      id: map['id'],
      walletID: map['walletID'],
      derivationPath: map['derivationPath'],
      label: map['label'],
      scriptType: map['scriptType'],
      createTime: map['createTime'],
      modifyTime: map['modifyTime'],
      serverAccountID: map['serverAccountID'] ?? "",
    );
    return accountModel;
  }
}
