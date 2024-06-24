// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/transaction_time.dart';
import '../../frb_generated.dart';
import 'derivation_path.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'transaction_details_txin.dart';
import 'transaction_details_txop.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FrbTransactionDetails>>
@sealed
class FrbTransactionDetails extends RustOpaque {
  FrbTransactionDetails.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  FrbTransactionDetails.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount: RustLib
        .instance.api.rust_arc_increment_strong_count_FrbTransactionDetails,
    rustArcDecrementStrongCount: RustLib
        .instance.api.rust_arc_decrement_strong_count_FrbTransactionDetails,
    rustArcDecrementStrongCountPtr: RustLib
        .instance.api.rust_arc_decrement_strong_count_FrbTransactionDetailsPtr,
  );

  FrbDerivationPath get accountDerivationPath =>
      RustLib.instance.api.frbTransactionDetailsAccountDerivationPath(
        that: this,
      );

  int? get fees => RustLib.instance.api.frbTransactionDetailsFees(
        that: this,
      );

  List<FrbDetailledTxIn> get inputs =>
      RustLib.instance.api.frbTransactionDetailsInputs(
        that: this,
      );

  List<FrbDetailledTxOutput> get outputs =>
      RustLib.instance.api.frbTransactionDetailsOutputs(
        that: this,
      );

  int get received => RustLib.instance.api.frbTransactionDetailsReceived(
        that: this,
      );

  int get sent => RustLib.instance.api.frbTransactionDetailsSent(
        that: this,
      );

  TransactionTime get time => RustLib.instance.api.frbTransactionDetailsTime(
        that: this,
      );

  String get txid => RustLib.instance.api.frbTransactionDetailsTxid(
        that: this,
      );
}
