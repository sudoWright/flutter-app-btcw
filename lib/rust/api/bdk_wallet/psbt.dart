// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../errors.dart';
import 'amount.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'transactions.dart';

// These functions are ignored because they are not marked as `pub`: `clone_inner`, `from_psbt`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `clone`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FrbPsbt>>
abstract class FrbPsbt implements RustOpaqueInterface {
  BigInt get computeTxVbytes;

  FrbTransaction extractTx();

  FrbAmount fee();

  List<FrbPsbtRecipient> get recipients;

  BigInt get totalFees;
}

class FrbPsbtRecipient {
  final String field0;
  final BigInt field1;

  const FrbPsbtRecipient({
    required this.field0,
    required this.field1,
  });

  @override
  int get hashCode => field0.hashCode ^ field1.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrbPsbtRecipient &&
          runtimeType == other.runtimeType &&
          field0 == other.field0 &&
          field1 == other.field1;
}
