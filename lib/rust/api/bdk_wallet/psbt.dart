// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/errors.dart';
import '../../frb_generated.dart';
import 'amount.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'transactions.dart';

// The type `FrbPsbtRecipient` is not used by any `pub` functions, thus it is ignored.

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FrbPsbt>>
@sealed
class FrbPsbt extends RustOpaque {
  FrbPsbt.dcoDecode(List<dynamic> wire) : super.dcoDecode(wire, _kStaticData);

  FrbPsbt.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_FrbPsbt,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_FrbPsbt,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_FrbPsbtPtr,
  );

  FrbTransaction extractTx({dynamic hint}) =>
      RustLib.instance.api.frbPsbtExtractTx(that: this, hint: hint);

  FrbAmount fee({dynamic hint}) =>
      RustLib.instance.api.frbPsbtFee(that: this, hint: hint);
}
