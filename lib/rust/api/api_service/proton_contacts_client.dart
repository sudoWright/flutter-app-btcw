// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/contacts.dart';
import '../errors.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ContactsClient>>
abstract class ContactsClient implements RustOpaqueInterface {
  Future<List<ApiContactEmails>> getContacts();

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<ContactsClient> newInstance(
          {required ProtonApiService service}) =>
      RustLib.instance.api
          .crateApiApiServiceProtonContactsClientContactsClientNew(
              service: service);
}
