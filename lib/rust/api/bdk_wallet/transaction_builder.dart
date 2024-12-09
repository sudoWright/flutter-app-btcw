// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/change_spend_policy.dart';
import '../../common/coin_selection.dart';
import '../../common/network.dart';
import '../../frb_generated.dart';
import '../errors.dart';
import 'account.dart';
import 'local_output.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'psbt.dart';

// These types are ignored because they are not used by any `pub` functions: `FrbRecipient`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `fmt`, `from`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FrbTxBuilder>>
abstract class FrbTxBuilder implements RustOpaqueInterface {
  FrbTxBuilder addRecipient({String? addressStr, BigInt? amount});

  FrbTxBuilder clearRecipients();

  FrbTxBuilder clearUtxosToSpend();

  Future<FrbTxBuilder> constrainRecipientAmounts();

  Future<FrbPsbt> createDraftPsbt({required Network network, bool? allowDust});

  ///     * Final
  ///
  Future<FrbPsbt> createPbst({required Network network});

  FrbTxBuilder disableRbf();

  ///     * RBF
  ///
  FrbTxBuilder enableRbf();

  ChangeSpendPolicy getChangePolicy();

  CoinSelection getCoinSelection();

  BigInt? getFeeRate();

  bool getRbfEnabled();

  List<FrbOutPoint> getUtxosToSpend();

  factory FrbTxBuilder() =>
      RustLib.instance.api.crateApiBdkWalletTransactionBuilderFrbTxBuilderNew();

  FrbTxBuilder removeLocktime();

  FrbTxBuilder removeRecipient({required BigInt index});

  Future<FrbTxBuilder> setAccount({required FrbAccount account});

  ///     * Change policy
  ///
  FrbTxBuilder setChangePolicy({required ChangeSpendPolicy changePolicy});

  ///     * Coin selection enforcement
  ///
  FrbTxBuilder setCoinSelection({required CoinSelection coinSelection});

  ///     * Fees
  ///
  Future<FrbTxBuilder> setFeeRate({required BigInt satPerVb});

  Future<FrbTxBuilder> updateRecipient(
      {required BigInt index, String? addressStr, BigInt? amount});

  Future<FrbTxBuilder> updateRecipientAmountToMax({required BigInt index});
}
