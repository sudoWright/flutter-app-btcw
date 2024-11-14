// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/exchange_rate.dart';
import '../../proton_api/user_settings.dart';
import '../../proton_api/wallet.dart';
import '../../proton_api/wallet_account.dart';
import '../../proton_api/wallet_settings.dart';
import '../errors.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletClient>>
abstract class WalletClient implements RustOpaqueInterface {
  /// wallet email related
  Future<ApiWalletAccount> addEmailAddress(
      {required String walletId,
      required String walletAccountId,
      required String addressId});

  Future<ApiWalletData> createWallet({required CreateWalletReq walletReq});

  Future<ApiWalletAccount> createWalletAccount(
      {required String walletId, required CreateWalletAccountReq req});

  Future<WalletTransaction> createWalletTransactions(
      {required String walletId,
      required String walletAccountId,
      required String transactionId,
      required String hashedTransactionId,
      String? label,
      String? exchangeRateId,
      String? transactionTime});

  Future<void> deleteWallet({required String walletId});

  Future<void> deleteWalletAccount(
      {required String walletId, required String walletAccountId});

  Future<void> deleteWalletTransaction(
      {required String walletId,
      required String walletAccountId,
      required String walletTransactionId});

  Future<WalletTransaction> deleteWalletTransactionPrivateFlag(
      {required String walletId,
      required String walletAccountId,
      required String walletTransactionId});

  Future<WalletTransaction> deleteWalletTransactionSuspiciousFlag(
      {required String walletId,
      required String walletAccountId,
      required String walletTransactionId});

  Future<ApiWalletSettings> disableShowWalletRecovery(
      {required String walletId});

  Future<List<ApiEmailAddress>> getWalletAccountAddresses(
      {required String walletId, required String walletAccountId});

  Future<List<ApiWalletAccount>> getWalletAccounts({required String walletId});

  /// Wallet transaction related
  Future<List<WalletTransaction>> getWalletTransactions(
      {required String walletId,
      String? walletAccountId,
      List<String>? hashedTxids});

  Future<List<ApiWalletData>> getWallets();

  Future<void> migrate(
      {required String walletId,
      required MigratedWallet migratedWallet,
      required List<MigratedWalletAccount> migratedWalletAccounts,
      required List<MigratedWalletTransaction> migratedWalletTransactions});

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<WalletClient> newInstance(
          {required ProtonApiService service}) =>
      RustLib.instance.api
          .crateApiApiServiceWalletClientWalletClientNew(service: service);

  Future<ApiWalletAccount> removeEmailAddress(
      {required String walletId,
      required String walletAccountId,
      required String addressId});

  Future<WalletTransaction> setWalletTransactionPrivateFlag(
      {required String walletId,
      required String walletAccountId,
      required String walletTransactionId});

  Future<WalletTransaction> setWalletTransactionSuspiciousFlag(
      {required String walletId,
      required String walletAccountId,
      required String walletTransactionId});

  Future<WalletTransaction> updateExternalWalletTransactionSender(
      {required String walletId,
      required String walletAccountId,
      required String walletTransactionId,
      required String sender});

  Future<ApiWalletAccount> updateWalletAccountFiatCurrency(
      {required String walletId,
      required String walletAccountId,
      required FiatCurrency newFiatCurrency});

  Future<ApiWalletAccount> updateWalletAccountLabel(
      {required String walletId,
      required String walletAccountId,
      required String newLabel});

  Future<ApiWalletAccount> updateWalletAccountLastUsedIndex(
      {required String walletId,
      required String walletAccountId,
      required int lastUsedIndex});

  Future<List<ApiWalletAccount>> updateWalletAccountsOrder(
      {required String walletId, required List<String> walletAccountIds});

  Future<ApiWallet> updateWalletName(
      {required String walletId, required String newName});

  Future<WalletTransaction> updateWalletTransactionLabel(
      {required String walletId,
      required String walletAccountId,
      required String walletTransactionId,
      required String label});
}
