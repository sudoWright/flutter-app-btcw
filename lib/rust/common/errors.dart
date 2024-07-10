// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'errors.freezed.dart';

@freezed
sealed class BridgeError with _$BridgeError implements FrbException {
  const BridgeError._();

  const factory BridgeError.apiLock(
    String field0,
  ) = BridgeError_ApiLock;

  /// Generic error
  const factory BridgeError.generic(
    String field0,
  ) = BridgeError_Generic;

  /// Muon auth session error
  const factory BridgeError.muonAuthSession(
    String field0,
  ) = BridgeError_MuonAuthSession;

  /// Muon auth refresh error
  const factory BridgeError.muonAuthRefresh(
    String field0,
  ) = BridgeError_MuonAuthRefresh;

  /// Muon client error
  const factory BridgeError.muonClient(
    String field0,
  ) = BridgeError_MuonClient;

  /// Muon session error
  const factory BridgeError.muonSession(
    String field0,
  ) = BridgeError_MuonSession;

  /// Andromeda bitcoin error
  const factory BridgeError.andromedaBitcoin(
    String field0,
  ) = BridgeError_AndromedaBitcoin;

  /// Andromeda api response error
  const factory BridgeError.apiResponse(
    ResponseError field0,
  ) = BridgeError_ApiResponse;

  /// srp errors
  const factory BridgeError.apiSrp(
    String field0,
  ) = BridgeError_ApiSrp;
}

class ResponseError {
  final int code;
  final String error;
  final String details;

  const ResponseError({
    required this.code,
    required this.error,
    required this.details,
  });

  @override
  int get hashCode => code.hashCode ^ error.hashCode ^ details.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseError &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          error == other.error &&
          details == other.details;
}
