// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.35.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class ApiUserSettings {
  final BitcoinUnit bitcoinUnit;
  final FiatCurrency fiatCurrency;
  final int hideEmptyUsedAddresses;
  final int showWalletRecovery;
  final int? twoFactorAmountThreshold;

  const ApiUserSettings({
    required this.bitcoinUnit,
    required this.fiatCurrency,
    required this.hideEmptyUsedAddresses,
    required this.showWalletRecovery,
    this.twoFactorAmountThreshold,
  });

  @override
  int get hashCode =>
      bitcoinUnit.hashCode ^
      fiatCurrency.hashCode ^
      hideEmptyUsedAddresses.hashCode ^
      showWalletRecovery.hashCode ^
      twoFactorAmountThreshold.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiUserSettings &&
          runtimeType == other.runtimeType &&
          bitcoinUnit == other.bitcoinUnit &&
          fiatCurrency == other.fiatCurrency &&
          hideEmptyUsedAddresses == other.hideEmptyUsedAddresses &&
          showWalletRecovery == other.showWalletRecovery &&
          twoFactorAmountThreshold == other.twoFactorAmountThreshold;
}

enum BitcoinUnit {
  /// 100,000,000 sats
  btc,

  /// 100,000 sats
  mbtc,

  /// 1 sat
  sats,
  ;
}

enum FiatCurrency {
  all,
  dzd,
  ars,
  amd,
  aud,
  azn,
  bhd,
  bdt,
  byn,
  bmd,
  bob,
  bam,
  brl,
  bgn,
  khr,
  cad,
  clp,
  cny,
  cop,
  crc,
  hrk,
  cup,
  czk,
  dkk,
  dop,
  egp,
  eur,
  gel,
  ghs,
  gtq,
  hnl,
  hkd,
  huf,
  isk,
  inr,
  idr,
  irr,
  iqd,
  ils,
  jmd,
  jpy,
  jod,
  kzt,
  kes,
  kwd,
  kgs,
  lbp,
  mkd,
  myr,
  mur,
  mxn,
  mdl,
  mnt,
  mad,
  mmk,
  nad,
  npr,
  twd,
  nzd,
  nio,
  ngn,
  nok,
  omr,
  pkr,
  pab,
  pen,
  php,
  pln,
  gbp,
  qar,
  ron,
  rub,
  sar,
  rsd,
  sgd,
  zar,
  krw,
  ssp,
  ves,
  lkr,
  sek,
  chf,
  thb,
  ttd,
  tnd,
  Try,
  ugx,
  uah,
  aed,
  usd,
  uyu,
  uzs,
  vnd,
  ;
}
