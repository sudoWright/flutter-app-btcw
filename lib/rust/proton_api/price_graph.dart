// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'user_settings.dart';

class DataPoint {
  final BigInt exchangeRate;
  final int? cents;
  final BigInt timestamp;

  const DataPoint({
    required this.exchangeRate,
    this.cents,
    required this.timestamp,
  });

  @override
  int get hashCode =>
      exchangeRate.hashCode ^ cents.hashCode ^ timestamp.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPoint &&
          runtimeType == other.runtimeType &&
          exchangeRate == other.exchangeRate &&
          cents == other.cents &&
          timestamp == other.timestamp;
}

class PriceGraph {
  final FiatCurrency? fiatCurrencySymbol;
  final BitcoinUnit? bitcoinUnitSymbol;
  final FiatCurrency? fiatCurrency;
  final BitcoinUnit? bitcoinUnit;
  final List<DataPoint> graphData;

  const PriceGraph({
    this.fiatCurrencySymbol,
    this.bitcoinUnitSymbol,
    this.fiatCurrency,
    this.bitcoinUnit,
    required this.graphData,
  });

  @override
  int get hashCode =>
      fiatCurrencySymbol.hashCode ^
      bitcoinUnitSymbol.hashCode ^
      fiatCurrency.hashCode ^
      bitcoinUnit.hashCode ^
      graphData.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceGraph &&
          runtimeType == other.runtimeType &&
          fiatCurrencySymbol == other.fiatCurrencySymbol &&
          bitcoinUnitSymbol == other.bitcoinUnitSymbol &&
          fiatCurrency == other.fiatCurrency &&
          bitcoinUnit == other.bitcoinUnit &&
          graphData == other.graphData;
}

enum Timeframe {
  oneDay,
  oneWeek,
  oneMonth,
  unsupported,
  ;
}
