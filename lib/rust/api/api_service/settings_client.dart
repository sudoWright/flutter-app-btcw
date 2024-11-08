// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/user_settings.dart';
import '../errors.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<SettingsClient>>
abstract class SettingsClient implements RustOpaqueInterface {
  Future<ApiWalletUserSettings> acceptTermsAndConditions();

  Future<ApiWalletUserSettings> bitcoinUnit({required BitcoinUnit symbol});

  Future<ApiWalletUserSettings> fiatCurrency({required FiatCurrency symbol});

  Future<ApiWalletUserSettings> getUserSettings();

  Future<int> getUserWalletEligibility();

  Future<ApiWalletUserSettings> hideEmptyUsedAddresses(
      {required bool hideEmptyUsedAddresses});

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<SettingsClient> newInstance(
          {required ProtonApiService service}) =>
      RustLib.instance.api
          .crateApiApiServiceSettingsClientSettingsClientNew(service: service);

  Future<ApiWalletUserSettings> receiveNotificationEmail(
      {required UserReceiveNotificationEmailTypes emailType,
      required bool isEnable});

  Future<ApiWalletUserSettings> twoFaThreshold({required BigInt amount});
}
