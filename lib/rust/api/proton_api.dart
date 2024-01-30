// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.21.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../proton_api/errors.dart';
import '../proton_api/types.dart';
import '../proton_api/wallet_account_routes.dart';
import '../proton_api/wallet_routes.dart';
import '../proton_api/wallet_settings_routes.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

Future<void> initApiService(
        {required String userName, required String password, dynamic hint}) =>
    RustLib.instance.api
        .initApiService(userName: userName, password: password, hint: hint);

Future<AuthInfo> fetchAuthInfo({required String userName, dynamic hint}) =>
    RustLib.instance.api.fetchAuthInfo(userName: userName, hint: hint);

Future<WalletsResponse> getWallets({dynamic hint}) =>
    RustLib.instance.api.getWallets(hint: hint);

Future<CreateWalletResponse> createWallet(
        {required CreateWalletReq walletReq, dynamic hint}) =>
    RustLib.instance.api.createWallet(walletReq: walletReq, hint: hint);

Future<WalletAccountsResponse> getWalletAccounts(
        {required String walletId, dynamic hint}) =>
    RustLib.instance.api.getWalletAccounts(walletId: walletId, hint: hint);

Future<WalletAccountResponse> createWalletAccount(
        {required String walletId,
        required CreateWalletAccountReq req,
        dynamic hint}) =>
    RustLib.instance.api
        .createWalletAccount(walletId: walletId, req: req, hint: hint);

Future<WalletAccountResponse> updateWalletAccountLabel(
        {required String walletId,
        required String walletAccountId,
        required String newLabel,
        dynamic hint}) =>
    RustLib.instance.api.updateWalletAccountLabel(
        walletId: walletId,
        walletAccountId: walletAccountId,
        newLabel: newLabel,
        hint: hint);

Future<ResponseCode> deleteWalletAccount(
        {required String walletId,
        required String walletAccountId,
        dynamic hint}) =>
    RustLib.instance.api.deleteWalletAccount(
        walletId: walletId, walletAccountId: walletAccountId, hint: hint);
