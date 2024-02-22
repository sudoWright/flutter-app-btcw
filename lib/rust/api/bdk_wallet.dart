// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../bdk/error.dart';
import '../bdk/network.dart';
import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class WalletManager {
  const WalletManager();

  static Future<WalletManager> newWalletManager(
          {required Network network,
          required String bip39Mnemonic,
          String? bip38Passphrase,
          dynamic hint}) =>
      RustLib.instance.api.walletManagerNew(
          network: network,
          bip39Mnemonic: bip39Mnemonic,
          bip38Passphrase: bip38Passphrase,
          hint: hint);

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletManager && runtimeType == other.runtimeType;
}
