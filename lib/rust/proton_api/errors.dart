// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'errors.freezed.dart';

@freezed
sealed class ApiError with _$ApiError implements FrbException {
  /// Generic error
  const factory ApiError.generic(
    String field0,
  ) = ApiError_Generic;

  /// Muon session error
  const factory ApiError.sessionError(
    String field0,
  ) = ApiError_SessionError;
}
