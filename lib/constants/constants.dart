import 'package:flutter/material.dart';
import 'package:wallet/rust/proton_api/user_settings.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;
const double defaultButtonPadding = 26.0;
const int exchangeRateRefreshThreshold = 10;
const int defaultBitcoinAddressCountForOneEmail = 10;
const int defaultTransactionPerPage = 3;
const int defaultDisplayDigits = 4;

const String userSettingsHideEmptyUsedAddresses =
    "userSettings.hideEmptyUsedAddresses";
const String userSettingsTwoFactorAmountThreshold =
    "userSettings.twoFactorAmountThreshold";
const String userSettingsShowWalletRecovery = "userSettings.showWalletRecovery";
const String userSettingsFiatCurrency = "userSettings.fiatCurrency";
const String userSettingsBitcoinUnit = "userSettings.bitcoinUnit";
const String latestAddressIndex = "bitcoinAddress.latest";

const List<BitcoinUnit> bitcoinUnits = [
  BitcoinUnit.btc,
  BitcoinUnit.mbtc,
  BitcoinUnit.sats,
];

