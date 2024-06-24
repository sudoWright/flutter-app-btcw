// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../common/errors.dart';
import '../common/network.dart';
import '../common/word_count.dart';
import '../frb_generated.dart';
import 'bdk_wallet/address.dart';
import 'bdk_wallet/blockchain.dart';
import 'bdk_wallet/derivation_path.dart';
import 'bdk_wallet/script_buf.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// The type `RUNTIME` is not used by any `pub` functions, thus it is ignored.

class Api {
  const Api();

  static Future<FrbAddress> addressFromScript(
          {required FrbScriptBuf script,
          required Network network,
          dynamic hint}) =>
      RustLib.instance.api
          .apiAddressFromScript(script: script, network: network, hint: hint);

  static Future<FrbAddress> createAddress(
          {required String address, required Network network, dynamic hint}) =>
      RustLib.instance.api
          .apiCreateAddress(address: address, network: network, hint: hint);

  static Future<FrbDerivationPath> createDerivationPath(
          {required String path, dynamic hint}) =>
      RustLib.instance.api.apiCreateDerivationPath(path: path, hint: hint);

  /// create esplora blockchain with proton api
  static Future<FrbBlockchainClient> createEsploraBlockchainWithApi(
          {dynamic hint}) =>
      RustLib.instance.api.apiCreateEsploraBlockchainWithApi(hint: hint);

  static Future<FrbScriptBuf> createScript(
          {required List<int> rawOutputScript, dynamic hint}) =>
      RustLib.instance.api
          .apiCreateScript(rawOutputScript: rawOutputScript, hint: hint);

  static Future<String> generateSeedFromString(
          {required String mnemonic, dynamic hint}) =>
      RustLib.instance.api
          .apiGenerateSeedFromString(mnemonic: mnemonic, hint: hint);

  ///================== Mnemonic ==========
  static Future<String> generateSeedFromWordCount(
          {required WordCount wordCount, dynamic hint}) =>
      RustLib.instance.api
          .apiGenerateSeedFromWordCount(wordCount: wordCount, hint: hint);

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Api && runtimeType == other.runtimeType;
}
