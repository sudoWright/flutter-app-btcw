// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.21.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../api/proton_api.dart';
import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class ProtonAPIService {
  final Session session;

  const ProtonAPIService({
    required this.session,
  });

  @override
  int get hashCode => session.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtonAPIService &&
          runtimeType == other.runtimeType &&
          session == other.session;
}
