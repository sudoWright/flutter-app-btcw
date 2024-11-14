// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_wallet/crypto/wallet_key.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `new`, `new`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FrbUnlockedWalletKey>>
abstract class FrbUnlockedWalletKey implements RustOpaqueInterface {
  String toBase64();

  Uint8List toEntropy();
}

class FrbLockedWalletKey {
  final LockedWalletKey field0;

  const FrbLockedWalletKey({
    required this.field0,
  });

  String getArmored() =>
      RustLib.instance.api.crateApiCryptoWalletKeyFrbLockedWalletKeyGetArmored(
        that: this,
      );

  String getSignature() => RustLib.instance.api
          .crateApiCryptoWalletKeyFrbLockedWalletKeyGetSignature(
        that: this,
      );

  @override
  int get hashCode => field0.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrbLockedWalletKey &&
          runtimeType == other.runtimeType &&
          field0 == other.field0;
}
