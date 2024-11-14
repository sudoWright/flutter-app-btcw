// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'transaction_time.freezed.dart';

@freezed
sealed class TransactionTime with _$TransactionTime {
  const TransactionTime._();

  const factory TransactionTime.confirmed({
    required BigInt confirmationTime,
  }) = TransactionTime_Confirmed;
  const factory TransactionTime.unconfirmed({
    required BigInt lastSeen,
  }) = TransactionTime_Unconfirmed;
}
