// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.35.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/errors.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class ProtonWalletAuthStore {
  const ProtonWalletAuthStore();

  static void setDartCallback(
          {required FutureOr<String> Function(String) callback,
          dynamic hint}) =>
      RustLib.instance.api
          .crateApiApiServiceWalletAuthStoreProtonWalletAuthStoreSetDartCallback(
              callback: callback, hint: hint);

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtonWalletAuthStore && runtimeType == other.runtimeType;
}
