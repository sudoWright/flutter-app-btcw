// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../errors.dart';
import 'account.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'psbt.dart';

// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `from`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Arc < ProtonAPIService >>>
abstract class ArcProtonApiService implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<FrbBlockchainClient>>
abstract class FrbBlockchainClient implements RustOpaqueInterface {
  Future<String> broadcastPsbt(
      {required FrbPsbt psbt,
      required String walletId,
      required String walletAccountId,
      String? label,
      String? exchangeRateId,
      String? transactionTime,
      String? addressId,
      String? body,
      Map<String, String>? recipients,
      int? isAnonymous});

  Future<void> fullSync({required FrbAccount account, BigInt? stopGap});

  Future<Map<String, double>> getFeesEstimation();

  factory FrbBlockchainClient({required ArcProtonApiService apiService}) =>
      RustLib.instance.api.crateApiBdkWalletBlockchainFrbBlockchainClientNew(
          apiService: apiService);

  Future<void> partialSync({required FrbAccount account});

  Future<bool> shouldSync({required FrbAccount account});
}
