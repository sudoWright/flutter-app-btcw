// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/errors.dart';
import '../../proton_api/wallet.dart';
import '../../proton_api/wallet_settings.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonAPIService>>
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
      RustLib.instance.api.protonApiServiceGetWallets(that: this, hint: hint);

  static Future<void> initApiService(
          {required String userName, required String password, dynamic hint}) =>
      RustLib.instance.api.protonApiServiceInitApiService(
          userName: userName, password: password, hint: hint);

  static Future<ProtonApiService> initWith(
          {required String uid,
          required String access,
          required String refresh,
          required List<String> scopes,
          required String appVersion,
          required String userAgent,
          String? env,
          dynamic hint}) =>
      RustLib.instance.api.protonApiServiceInitWith(
          uid: uid,
          access: access,
          refresh: refresh,
          scopes: scopes,
          appVersion: appVersion,
          userAgent: userAgent,
          env: env,
          hint: hint);

  Future<String> readText({dynamic hint}) =>
      RustLib.instance.api.protonApiServiceReadText(that: this, hint: hint);
}
