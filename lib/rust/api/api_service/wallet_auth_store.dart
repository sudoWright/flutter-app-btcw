// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.28.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// The type `GLOBAL_CALLBACK` is not used by any `pub` functions, thus it is ignored.
// The type `WalletAuthStore` is not used by any `pub` functions, thus it is ignored.

Future<void> setDartCallback(
        {required FutureOr<String> Function(String) callback, dynamic hint}) =>
    RustLib.instance.api.setDartCallback(callback: callback, hint: hint);
