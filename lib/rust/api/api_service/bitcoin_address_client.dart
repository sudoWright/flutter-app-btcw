// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../common/errors.dart';
import '../../frb_generated.dart';
import '../../proton_api/wallet.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'proton_api_service.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<BitcoinAddressClient>>
abstract class BitcoinAddressClient implements RustOpaqueInterface {
  Future<List<ApiWalletBitcoinAddress>> addBitcoinAddresses(
      {required String walletId,
      required String walletAccountId,
      required List<BitcoinAddress> bitcoinAddresses});

  Future<BigInt> getBitcoinAddressLatestIndex(
      {required String walletId, required String walletAccountId});

  Future<List<ApiWalletBitcoinAddress>> getWalletBitcoinAddress(
      {required String walletId,
      required String walletAccountId,
      int? onlyRequest});

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<BitcoinAddressClient> newInstance(
          {required ProtonApiService service}) =>
      RustLib.instance.api
          .crateApiApiServiceBitcoinAddressClientBitcoinAddressClientNew(
              service: service);

  Future<ApiWalletBitcoinAddress> updateBitcoinAddress(
      {required String walletId,
      required String walletAccountId,
      required String walletAccountBitcoinAddressId,
      required BitcoinAddress bitcoinAddress});
}
