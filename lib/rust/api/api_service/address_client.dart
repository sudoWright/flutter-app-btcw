// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/errors.dart';
import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<AddressBalance>>
abstract class AddressBalance implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<AddressClient>>
abstract class AddressClient implements RustOpaqueInterface {
  /// Get recent block summaries, starting at tip or height if provided
  Future<AddressBalance> getAddressBalance({required String address});

  /// Get a [`BlockHeader`] given a particular block hash.
  Future<List<ApiTx>> getScripthashTransactions({required String scriptHash});

  /// Get a [`BlockHeader`] given a particular block hash.
  Future<List<ApiTx>> getScripthashTransactionsAtTransactionId(
      {required String scriptHash, required String transactionId});

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<AddressClient> newInstance(
          {required ProtonApiService service}) =>
      RustLib.instance.api
          .crateApiApiServiceAddressClientAddressClientNew(service: service);
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ApiTx>>
abstract class ApiTx implements RustOpaqueInterface {}
