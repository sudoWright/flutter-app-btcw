// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/errors.dart';
import '../../frb_generated.dart';
import '../../proton_api/proton_users.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonSettingsClient>>
@sealed
class ProtonSettingsClient extends RustOpaque {
  ProtonSettingsClient.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  ProtonSettingsClient.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount: RustLib
        .instance.api.rust_arc_increment_strong_count_ProtonSettingsClient,
    rustArcDecrementStrongCount: RustLib
        .instance.api.rust_arc_decrement_strong_count_ProtonSettingsClient,
    rustArcDecrementStrongCountPtr: RustLib
        .instance.api.rust_arc_decrement_strong_count_ProtonSettingsClientPtr,
  );

  Future<String> disableMnemonicSettings(
          {required ProtonSrpClientProofs proofs, dynamic hint}) =>
      RustLib.instance.api.protonSettingsClientDisableMnemonicSettings(
          that: this, proofs: proofs, hint: hint);

  Future<List<ApiMnemonicUserKey>> getMnemonicSettings({dynamic hint}) =>
      RustLib.instance.api
          .protonSettingsClientGetMnemonicSettings(that: this, hint: hint);

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<ProtonSettingsClient> newInstance(
          {required ProtonApiService client, dynamic hint}) =>
      RustLib.instance.api.protonSettingsClientNew(client: client, hint: hint);

  Future<int> reactiveMnemonicSettings(
          {required UpdateMnemonicSettingsRequestBody req, dynamic hint}) =>
      RustLib.instance.api.protonSettingsClientReactiveMnemonicSettings(
          that: this, req: req, hint: hint);

  Future<int> setMnemonicSettings(
          {required UpdateMnemonicSettingsRequestBody req, dynamic hint}) =>
      RustLib.instance.api.protonSettingsClientSetMnemonicSettings(
          that: this, req: req, hint: hint);
}
