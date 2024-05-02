// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.28.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../bdk/error.dart';
import '../bdk/types.dart';
import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::rust_async::RwLock<BdkWalletManager>>
@sealed
class BdkWalletManager extends RustOpaque {
  BdkWalletManager.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  BdkWalletManager.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_BdkWalletManager,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_BdkWalletManager,
    rustArcDecrementStrongCountPtr: RustLib
        .instance.api.rust_arc_decrement_strong_count_BdkWalletManagerPtr,
  );

  Future<String> getFingerprint({dynamic hint}) =>
      RustLib.instance.api.bdkWalletManagerGetFingerprint(
        that: this,
      );

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<BdkWalletManager> newInstance(
          {required Network network,
          required String bip39Mnemonic,
          String? bip38Passphrase,
          dynamic hint}) =>
      RustLib.instance.api.bdkWalletManagerNew(
          network: network,
          bip39Mnemonic: bip39Mnemonic,
          bip38Passphrase: bip38Passphrase,
          hint: hint);
}
