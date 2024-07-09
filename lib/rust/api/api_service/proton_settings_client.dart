// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/errors.dart';
import '../../frb_generated.dart';
import '../../proton_api/proton_users.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonSettingsClient>>
abstract class ProtonSettingsClient implements RustOpaqueInterface {
  Future<String> disableMnemonicSettings(
      {required ProtonSrpClientProofs proofs});

  Future<List<ApiMnemonicUserKey>> getMnemonicSettings();

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<ProtonSettingsClient> newInstance(
          {required ProtonApiService client}) =>
      RustLib.instance.api
          .crateApiApiServiceProtonSettingsClientProtonSettingsClientNew(
              client: client);

  Future<int> reactiveMnemonicSettings(
      {required UpdateMnemonicSettingsRequestBody req});

  Future<int> setMnemonicSettings(
      {required UpdateMnemonicSettingsRequestBody req});
}
