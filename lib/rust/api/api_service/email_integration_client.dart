// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/wallet.dart';
import '../errors.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<EmailIntegrationClient>>
abstract class EmailIntegrationClient implements RustOpaqueInterface {
  Future<EmailIntegrationBitcoinAddress> lookupBitcoinAddress(
      {required String email});

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<EmailIntegrationClient> newInstance(
          {required ProtonApiService service}) =>
      RustLib.instance.api
          .crateApiApiServiceEmailIntegrationClientEmailIntegrationClientNew(
              service: service);
}
