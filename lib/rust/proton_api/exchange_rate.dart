// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.28.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'user_settings.dart';

class ProtonExchangeRate {
  /// An encrypted ID
  final String id;

  /// Bitcoin unit of the exchange rate
  final CommonBitcoinUnit bitcoinUnit;

  /// Fiat currency of the exchange rate
  final FiatCurrency fiatCurrency;

  /// string <date-time>
  final String exchangeRateTime;

  /// Exchange rate BitcoinUnit/FiatCurrency
  final int exchangeRate;

  /// Cents precision of the fiat currency (e.g. 1 for JPY, 100 for USD)
  final int cents;

  const ProtonExchangeRate({
    required this.id,
    required this.bitcoinUnit,
    required this.fiatCurrency,
    required this.exchangeRateTime,
    required this.exchangeRate,
    required this.cents,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      bitcoinUnit.hashCode ^
      fiatCurrency.hashCode ^
      exchangeRateTime.hashCode ^
      exchangeRate.hashCode ^
      cents.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtonExchangeRate &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          bitcoinUnit == other.bitcoinUnit &&
          fiatCurrency == other.fiatCurrency &&
          exchangeRateTime == other.exchangeRateTime &&
          exchangeRate == other.exchangeRate &&
          cents == other.cents;
}
