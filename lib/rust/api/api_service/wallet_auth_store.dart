// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/errors.dart';
import '../../frb_generated.dart';
import '../../proton_api/auth_credential.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// The type `GLOBAL_SESSION_DART_CALLBACK` is not used by any `pub` functions, thus it is ignored.

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonWalletAuthStore>>
@sealed
class ProtonWalletAuthStore extends RustOpaque {
  ProtonWalletAuthStore.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  ProtonWalletAuthStore.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount: RustLib
        .instance.api.rust_arc_increment_strong_count_ProtonWalletAuthStore,
    rustArcDecrementStrongCount: RustLib
        .instance.api.rust_arc_decrement_strong_count_ProtonWalletAuthStore,
    rustArcDecrementStrongCountPtr: RustLib
        .instance.api.rust_arc_decrement_strong_count_ProtonWalletAuthStorePtr,
  );

  Future<void> clearAuthDartCallback({dynamic hint}) => RustLib.instance.api
      .protonWalletAuthStoreClearAuthDartCallback(that: this, hint: hint);

  static ProtonWalletAuthStore fromSession(
          {required String env,
          required String uid,
          required String access,
          required String refresh,
          required List<String> scopes,
          dynamic hint}) =>
      RustLib.instance.api.protonWalletAuthStoreFromSession(
          env: env,
          uid: uid,
          access: access,
          refresh: refresh,
          scopes: scopes,
          hint: hint);

  Future<void> logout({dynamic hint}) =>
      RustLib.instance.api.protonWalletAuthStoreLogout(that: this, hint: hint);

  factory ProtonWalletAuthStore({required String env, dynamic hint}) =>
      RustLib.instance.api.protonWalletAuthStoreNew(env: env, hint: hint);

  Future<void> setAuthDartCallback(
          {required FutureOr<String> Function(ChildSession) callback,
          dynamic hint}) =>
      RustLib.instance.api.protonWalletAuthStoreSetAuthDartCallback(
          that: this, callback: callback, hint: hint);

  void setAuthSync(
          {required String uid,
          required String access,
          required String refresh,
          required List<String> scopes,
          dynamic hint}) =>
      RustLib.instance.api.protonWalletAuthStoreSetAuthSync(
          that: this,
          uid: uid,
          access: access,
          refresh: refresh,
          scopes: scopes,
          hint: hint);
}
