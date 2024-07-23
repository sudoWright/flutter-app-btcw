// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/errors.dart';
import '../../frb_generated.dart';
import '../../proton_api/invite.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<InviteClient>>
abstract class InviteClient implements RustOpaqueInterface {
  Future<int> checkInviteStatus(
      {required String inviteeEmail,
      required InviteNotificationType inviteNotificationType,
      required String inviterAddressId});

  Future<RemainingMonthlyInvitations> getRemainingMonthlyInvitation();

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<InviteClient> newInstance(
          {required ProtonApiService service}) =>
      RustLib.instance.api
          .crateApiApiServiceInviteClientInviteClientNew(service: service);

  Future<void> sendEmailIntegrationInvite(
      {required String inviteeEmail, required String inviterAddressId});

  Future<void> sendNewcomerInvite(
      {required String inviteeEmail, required String inviterAddressId});
}
