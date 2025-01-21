// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/address_info.dart';
import '../../common/keychain_kind.dart';
import '../../common/network.dart';
import '../../common/pagination.dart';
import '../../common/script_type.dart';
import '../../frb_generated.dart';
import '../errors.dart';
import 'address.dart';
import 'balance.dart';
import 'blockchain.dart';
import 'derivation_path.dart';
import 'local_output.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'psbt.dart';
import 'storage.dart';
import 'transaction_builder.dart';
import 'transaction_details.dart';
import 'wallet.dart';

// These functions are ignored because they are not marked as `pub`: `get_inner`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `from`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FrbAccount>>
abstract class FrbAccount implements RustOpaqueInterface {
  Future<FrbTxBuilder> buildTx();

  Future<FrbPsbt> bumpTransactionsFees(
      {required String txid, required BigInt fees, required Network network});

  Future<FrbAddressInfo> getAddress({int? index});

  Future<FrbAddressDetails?> getAddressFromGraph(
      {required Network network,
      required String addressStr,
      required FrbBlockchainClient client,
      required bool sync_});

  Future<List<FrbAddressDetails>> getAddressesFromGraph(
      {required Pagination pagination,
      required FrbBlockchainClient client,
      required KeychainKind keychain,
      required bool sync_});

  Future<FrbBalance> getBalance();

  Future<String> getDerivationPath();

  Future<int?> getHighestUsedAddressIndexInOutput(
      {required KeychainKind keychain});

  Future<int?> getMaximumGapSize({required KeychainKind keychain});

  Future<FrbAddressInfo> getNextReceiveAddress();

  Future<FrbTransactionDetails> getTransaction({required String txid});

  Future<List<FrbTransactionDetails>> getTransactions({SortOrder? sort});

  Future<List<FrbLocalOutput>> getUtxos();

  Future<bool> hasSyncData();

  Future<bool> isMine({required FrbAddress address});

  Future<void> markReceiveAddressesUsedTo({required int from, int? to});

  /// Usually creating account need to through wallet.
  ///  this shouldn't be used. just for sometimes we need it without wallet.
  factory FrbAccount(
          {required FrbWallet wallet,
          required ScriptType scriptType,
          required FrbDerivationPath derivationPath,
          required WalletMobileConnectorFactory storageFactory}) =>
      RustLib.instance.api.crateApiBdkWalletAccountFrbAccountNew(
          wallet: wallet,
          scriptType: scriptType,
          derivationPath: derivationPath,
          storageFactory: storageFactory);

  Future<FrbPsbt> sign({required FrbPsbt psbt, required Network network});
}
