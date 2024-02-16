// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../proton_api/errors.dart';
import '../proton_api/wallet.dart';
import '../proton_api/wallet_account.dart';
import '../proton_api/wallet_settings.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<void> initApiService(
        {required String userName, required String password, dynamic hint}) =>
    RustLib.instance.api
        .initApiService(userName: userName, password: password, hint: hint);

Future<List<WalletData>> getWallets({dynamic hint}) =>
    RustLib.instance.api.getWallets(hint: hint);

Future<WalletData> createWallet(
        {required CreateWalletReq walletReq, dynamic hint}) =>
    RustLib.instance.api.createWallet(walletReq: walletReq, hint: hint);

Future<List<WalletAccount>> getWalletAccounts(
        {required String walletId, dynamic hint}) =>
    RustLib.instance.api.getWalletAccounts(walletId: walletId, hint: hint);

Future<WalletAccount> createWalletAccount(
        {required String walletId,
        required CreateWalletAccountReq req,
        dynamic hint}) =>
    RustLib.instance.api
        .createWalletAccount(walletId: walletId, req: req, hint: hint);

Future<WalletAccount> updateWalletAccountLabel(
        {required String walletId,
        required String walletAccountId,
        required String newLabel,
        dynamic hint}) =>
    RustLib.instance.api.updateWalletAccountLabel(
        walletId: walletId,
        walletAccountId: walletAccountId,
        newLabel: newLabel,
        hint: hint);

Future<void> deleteWalletAccount(
        {required String walletId,
        required String walletAccountId,
        dynamic hint}) =>
    RustLib.instance.api.deleteWalletAccount(
        walletId: walletId, walletAccountId: walletAccountId, hint: hint);
