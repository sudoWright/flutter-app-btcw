// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/address_info.dart';
import '../../common/errors.dart';
import '../../common/keychain_kind.dart';
import '../../common/network.dart';
import '../../common/pagination.dart';
import '../../common/script_type.dart';
import '../../frb_generated.dart';
import 'address.dart';
import 'balance.dart';
import 'derivation_path.dart';
import 'local_output.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'payment_link.dart';
import 'psbt.dart';
import 'storage.dart';
import 'transaction_builder.dart';
import 'transaction_details.dart';
import 'wallet.dart';

// These functions are ignored because they are not marked as `pub`: `get_inner`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `fmt`, `from`, `from`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FrbAccount>>
abstract class FrbAccount implements RustOpaqueInterface {
  Future<FrbTxBuilder> buildTx();

  Future<FrbAddressInfo> getAddress({int? index});

  Future<FrbBalance> getBalance();

  Future<FrbPaymentLink> getBitcoinUri(
      {int? index, BigInt? amount, String? label, String? message});

  Future<String> getDerivationPath();

  Future<int> getIndexAfterLastUsedAddress();

  Future<int?> getLastUnusedAddressIndex();

  Future<FrbTransactionDetails> getTransaction({required String txid});

  Future<List<FrbTransactionDetails>> getTransactions(
      {Pagination? pagination, SortOrder? sort});

  Future<List<FrbLocalOutput>> getUtxos();

  Future<bool> hasSyncData();

  Future<void> insertUnconfirmedTx({required FrbPsbt psbt});

  Future<bool> isMine({required FrbAddress address});

  /// Usually creating account need to through wallet.
  ///  this shouldn't be used. just for sometimes we need it without wallet.
  factory FrbAccount(
          {required FrbWallet wallet,
          required ScriptType scriptType,
          required FrbDerivationPath derivationPath,
          required OnchainStoreFactory storageFactory}) =>
      RustLib.instance.api.crateApiBdkWalletAccountFrbAccountNew(
          wallet: wallet,
          scriptType: scriptType,
          derivationPath: derivationPath,
          storageFactory: storageFactory);

  Future<FrbPsbt> sign({required FrbPsbt psbt, required Network network});
}
