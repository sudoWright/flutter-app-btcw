// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.28.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/errors.dart';
import '../../proton_api/wallet.dart';
import '../../proton_api/wallet_settings.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::rust_async::RwLock<ProtonAPIService>>
@sealed
class ProtonApiService extends RustOpaque {
  ProtonApiService.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  ProtonApiService.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_ProtonApiService,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_ProtonApiService,
    rustArcDecrementStrongCountPtr: RustLib
        .instance.api.rust_arc_decrement_strong_count_ProtonApiServicePtr,
  );

  Future<List<WalletData>> getWallets({dynamic hint}) =>
      RustLib.instance.api.protonApiServiceGetWallets(
        that: this,
      );

  static Future<void> initApiService(
          {required String userName, required String password, dynamic hint}) =>
      RustLib.instance.api.protonApiServiceInitApiService(
          userName: userName, password: password, hint: hint);

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<ProtonApiService> newInstance({dynamic hint}) =>
      RustLib.instance.api.protonApiServiceNew(hint: hint);

  Future<String> readText({dynamic hint}) =>
      RustLib.instance.api.protonApiServiceReadText(
        that: this,
      );
}
