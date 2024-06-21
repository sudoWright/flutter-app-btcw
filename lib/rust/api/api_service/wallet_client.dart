// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/errors.dart';
import '../../proton_api/exchange_rate.dart';
import '../../proton_api/user_settings.dart';
import '../../proton_api/wallet.dart';
import '../../proton_api/wallet_account.dart';
import '../../proton_api/wallet_settings.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletClient>>
@sealed
class WalletClient extends RustOpaque {
  WalletClient.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  WalletClient.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_WalletClient,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_WalletClient,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_WalletClientPtr,
  );

  /// wallet email related
  Future<ApiWalletAccount> addEmailAddress(
          {required String walletId,
          required String walletAccountId,
          required String addressId,
          dynamic hint}) =>
      RustLib.instance.api.walletClientAddEmailAddress(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          addressId: addressId,
          hint: hint);

  Future<ApiWalletData> createWallet(
          {required CreateWalletReq walletReq, dynamic hint}) =>
      RustLib.instance.api.walletClientCreateWallet(
          that: this, walletReq: walletReq, hint: hint);

  Future<ApiWalletAccount> createWalletAccount(
          {required String walletId,
          required CreateWalletAccountReq req,
          dynamic hint}) =>
      RustLib.instance.api.walletClientCreateWalletAccount(
          that: this, walletId: walletId, req: req, hint: hint);

  Future<WalletTransaction> createWalletTransactions(
          {required String walletId,
          required String walletAccountId,
          required String transactionId,
          required String hashedTransactionId,
          String? label,
          String? exchangeRateId,
          String? transactionTime,
          dynamic hint}) =>
      RustLib.instance.api.walletClientCreateWalletTransactions(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          transactionId: transactionId,
          hashedTransactionId: hashedTransactionId,
          label: label,
          exchangeRateId: exchangeRateId,
          transactionTime: transactionTime,
          hint: hint);

  Future<void> deleteWallet({required String walletId, dynamic hint}) =>
      RustLib.instance.api
          .walletClientDeleteWallet(that: this, walletId: walletId, hint: hint);

  Future<void> deleteWalletAccount(
          {required String walletId,
          required String walletAccountId,
          dynamic hint}) =>
      RustLib.instance.api.walletClientDeleteWalletAccount(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          hint: hint);

  Future<WalletTransaction> deleteWalletTransactionPrivateFlag(
          {required String walletId,
          required String walletAccountId,
          required String walletTransactionId,
          dynamic hint}) =>
      RustLib.instance.api.walletClientDeleteWalletTransactionPrivateFlag(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          walletTransactionId: walletTransactionId,
          hint: hint);

  Future<WalletTransaction> deleteWalletTransactionSuspiciousFlag(
          {required String walletId,
          required String walletAccountId,
          required String walletTransactionId,
          dynamic hint}) =>
      RustLib.instance.api.walletClientDeleteWalletTransactionSuspiciousFlag(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          walletTransactionId: walletTransactionId,
          hint: hint);

  Future<void> deleteWalletTransactions(
          {required String walletId,
          required String walletAccountId,
          required String walletTransactionId,
          dynamic hint}) =>
      RustLib.instance.api.walletClientDeleteWalletTransactions(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          walletTransactionId: walletTransactionId,
          hint: hint);

  Future<List<ApiWalletAccount>> getWalletAccounts(
          {required String walletId, dynamic hint}) =>
      RustLib.instance.api.walletClientGetWalletAccounts(
          that: this, walletId: walletId, hint: hint);

  /// Wallet transaction related
  Future<List<WalletTransaction>> getWalletTransactions(
          {required String walletId,
          String? walletAccountId,
          List<String>? hashedTxids,
          dynamic hint}) =>
      RustLib.instance.api.walletClientGetWalletTransactions(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          hashedTxids: hashedTxids,
          hint: hint);

  Future<List<ApiWalletData>> getWallets({dynamic hint}) =>
      RustLib.instance.api.walletClientGetWallets(that: this, hint: hint);

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<WalletClient> newInstance(
          {required ProtonApiService service, dynamic hint}) =>
      RustLib.instance.api.walletClientNew(service: service, hint: hint);

  Future<ApiWalletAccount> removeEmailAddress(
          {required String walletId,
          required String walletAccountId,
          required String addressId,
          dynamic hint}) =>
      RustLib.instance.api.walletClientRemoveEmailAddress(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          addressId: addressId,
          hint: hint);

  Future<WalletTransaction> setWalletTransactionPrivateFlag(
          {required String walletId,
          required String walletAccountId,
          required String walletTransactionId,
          dynamic hint}) =>
      RustLib.instance.api.walletClientSetWalletTransactionPrivateFlag(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          walletTransactionId: walletTransactionId,
          hint: hint);

  Future<WalletTransaction> setWalletTransactionSuspiciousFlag(
          {required String walletId,
          required String walletAccountId,
          required String walletTransactionId,
          dynamic hint}) =>
      RustLib.instance.api.walletClientSetWalletTransactionSuspiciousFlag(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          walletTransactionId: walletTransactionId,
          hint: hint);

  Future<ApiWalletAccount> updateWalletAccountLabel(
          {required String walletId,
          required String walletAccountId,
          required String newLabel,
          dynamic hint}) =>
      RustLib.instance.api.walletClientUpdateWalletAccountLabel(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          newLabel: newLabel,
          hint: hint);

  Future<ApiWallet> updateWalletName(
          {required String walletId, required String newName, dynamic hint}) =>
      RustLib.instance.api.walletClientUpdateWalletName(
          that: this, walletId: walletId, newName: newName, hint: hint);

  Future<WalletTransaction> updateWalletTransactionExternalSender(
          {required String walletId,
          required String walletAccountId,
          required String walletTransactionId,
          required String sender,
          dynamic hint}) =>
      RustLib.instance.api.walletClientUpdateWalletTransactionExternalSender(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          walletTransactionId: walletTransactionId,
          sender: sender,
          hint: hint);

  Future<WalletTransaction> updateWalletTransactionLabel(
          {required String walletId,
          required String walletAccountId,
          required String walletTransactionId,
          required String label,
          dynamic hint}) =>
      RustLib.instance.api.walletClientUpdateWalletTransactionLabel(
          that: this,
          walletId: walletId,
          walletAccountId: walletAccountId,
          walletTransactionId: walletTransactionId,
          label: label,
          hint: hint);
}
