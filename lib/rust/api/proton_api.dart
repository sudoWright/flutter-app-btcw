// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../proton_api/auth_credential.dart';
import '../proton_api/exchange_rate.dart';
import '../proton_api/proton_address.dart';
import '../proton_api/user_settings.dart';
import '../proton_api/wallet.dart';
import '../proton_api/wallet_account.dart';
import 'errors.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// These functions are ignored because they are not marked as `pub`: `logout`, `retrieve_proton_api`, `set_proton_api`
// These types are ignored because they are not used by any `pub` functions: `PROTON_API`
// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `deref`, `initialize`

/// proton_api.getexchangerate
Future<ProtonExchangeRate> getExchangeRate(
        {required FiatCurrency fiatCurrency, BigInt? time}) =>
    RustLib.instance.api.crateApiProtonApiGetExchangeRate(
        fiatCurrency: fiatCurrency, time: time);

/// proton_api.getprotonaddress
Future<List<ProtonAddress>> getProtonAddress() =>
    RustLib.instance.api.crateApiProtonApiGetProtonAddress();

/// proton_api.addemailaddress
Future<ApiWalletAccount> addEmailAddress(
        {required String walletId,
        required String walletAccountId,
        required String addressId}) =>
    RustLib.instance.api.crateApiProtonApiAddEmailAddress(
        walletId: walletId,
        walletAccountId: walletAccountId,
        addressId: addressId);

/// proton_api.updatebitcoinaddress
Future<ApiWalletBitcoinAddress> updateBitcoinAddress(
        {required String walletId,
        required String walletAccountId,
        required String walletAccountBitcoinAddressId,
        required BitcoinAddress bitcoinAddress}) =>
    RustLib.instance.api.crateApiProtonApiUpdateBitcoinAddress(
        walletId: walletId,
        walletAccountId: walletAccountId,
        walletAccountBitcoinAddressId: walletAccountBitcoinAddressId,
        bitcoinAddress: bitcoinAddress);

/// proton_api.addbitcoinaddresses
Future<List<ApiWalletBitcoinAddress>> addBitcoinAddresses(
        {required String walletId,
        required String walletAccountId,
        required List<BitcoinAddress> bitcoinAddresses}) =>
    RustLib.instance.api.crateApiProtonApiAddBitcoinAddresses(
        walletId: walletId,
        walletAccountId: walletAccountId,
        bitcoinAddresses: bitcoinAddresses);

/// proton_api.lookupbitcoinaddress
Future<EmailIntegrationBitcoinAddress> lookupBitcoinAddress(
        {required String email}) =>
    RustLib.instance.api.crateApiProtonApiLookupBitcoinAddress(email: email);

/// proton_api.getwalletbitcoinaddress
Future<List<ApiWalletBitcoinAddress>> getWalletBitcoinAddress(
        {required String walletId,
        required String walletAccountId,
        int? onlyRequest}) =>
    RustLib.instance.api.crateApiProtonApiGetWalletBitcoinAddress(
        walletId: walletId,
        walletAccountId: walletAccountId,
        onlyRequest: onlyRequest);

/// proton_api.createwallettransactions
Future<WalletTransaction> createWalletTransactions(
        {required String walletId,
        required String walletAccountId,
        required String transactionId,
        required String hashedTransactionId,
        String? label,
        String? exchangeRateId,
        String? transactionTime}) =>
    RustLib.instance.api.crateApiProtonApiCreateWalletTransactions(
        walletId: walletId,
        walletAccountId: walletAccountId,
        transactionId: transactionId,
        hashedTransactionId: hashedTransactionId,
        label: label,
        exchangeRateId: exchangeRateId,
        transactionTime: transactionTime);

/// proton_api.fork
Future<ChildSession> fork(
        {required String appVersion,
        required String userAgent,
        required String clientChild}) =>
    RustLib.instance.api.crateApiProtonApiFork(
        appVersion: appVersion, userAgent: userAgent, clientChild: clientChild);

/// proton_api.fork
Future<String> forkSelector({required String clientChild}) =>
    RustLib.instance.api
        .crateApiProtonApiForkSelector(clientChild: clientChild);
