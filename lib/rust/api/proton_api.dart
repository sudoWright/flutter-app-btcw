// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.35.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../proton_api/contacts.dart';
import '../proton_api/errors.dart';
import '../proton_api/event_routes.dart';
import '../proton_api/exchange_rate.dart';
import '../proton_api/proton_address.dart';
import '../proton_api/user_settings.dart';
import '../proton_api/wallet.dart';
import '../proton_api/wallet_account.dart';
import '../proton_api/wallet_settings.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// The type `PROTON_API` is not used by any `pub` functions, thus it is ignored.

Future<void> initApiService(
        {required String userName, required String password, dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiInitApiService(
        userName: userName, password: password, hint: hint);

Future<void> initApiServiceAuthStore(
        {required String uid,
        required String access,
        required String refresh,
        required List<String> scopes,
        required String appVersion,
        required String userAgent,
        String? env,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiInitApiServiceAuthStore(
        uid: uid,
        access: access,
        refresh: refresh,
        scopes: scopes,
        appVersion: appVersion,
        userAgent: userAgent,
        env: env,
        hint: hint);

Future<void> initApiServiceFromAuthAndVersion(
        {required String uid,
        required String access,
        required String refresh,
        required List<String> scopes,
        required String appVersion,
        required String userAgent,
        String? env,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiInitApiServiceFromAuthAndVersion(
        uid: uid,
        access: access,
        refresh: refresh,
        scopes: scopes,
        appVersion: appVersion,
        userAgent: userAgent,
        env: env,
        hint: hint);

Future<List<WalletData>> getWallets({dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetWallets(hint: hint);

Future<WalletData> createWallet(
        {required CreateWalletReq walletReq, dynamic hint}) =>
    RustLib.instance.api
        .crateApiProtonApiCreateWallet(walletReq: walletReq, hint: hint);

Future<ProtonWallet> updateWalletName(
        {required String walletId, required String newName, dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiUpdateWalletName(
        walletId: walletId, newName: newName, hint: hint);

Future<void> deleteWallet({required String walletId, dynamic hint}) =>
    RustLib.instance.api
        .crateApiProtonApiDeleteWallet(walletId: walletId, hint: hint);

Future<List<WalletAccount>> getWalletAccounts(
        {required String walletId, dynamic hint}) =>
    RustLib.instance.api
        .crateApiProtonApiGetWalletAccounts(walletId: walletId, hint: hint);

Future<WalletAccount> createWalletAccount(
        {required String walletId,
        required CreateWalletAccountReq req,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiCreateWalletAccount(
        walletId: walletId, req: req, hint: hint);

Future<WalletAccount> updateWalletAccountLabel(
        {required String walletId,
        required String walletAccountId,
        required String newLabel,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiUpdateWalletAccountLabel(
        walletId: walletId,
        walletAccountId: walletAccountId,
        newLabel: newLabel,
        hint: hint);

Future<void> deleteWalletAccount(
        {required String walletId,
        required String walletAccountId,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiDeleteWalletAccount(
        walletId: walletId, walletAccountId: walletAccountId, hint: hint);

Future<ApiUserSettings> getUserSettings({dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetUserSettings(hint: hint);

Future<ApiUserSettings> bitcoinUnit(
        {required BitcoinUnit symbol, dynamic hint}) =>
    RustLib.instance.api
        .crateApiProtonApiBitcoinUnit(symbol: symbol, hint: hint);

Future<ApiUserSettings> fiatCurrency(
        {required FiatCurrency symbol, dynamic hint}) =>
    RustLib.instance.api
        .crateApiProtonApiFiatCurrency(symbol: symbol, hint: hint);

Future<ApiUserSettings> twoFaThreshold({required int amount, dynamic hint}) =>
    RustLib.instance.api
        .crateApiProtonApiTwoFaThreshold(amount: amount, hint: hint);

Future<ApiUserSettings> hideEmptyUsedAddresses(
        {required bool hideEmptyUsedAddresses, dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiHideEmptyUsedAddresses(
        hideEmptyUsedAddresses: hideEmptyUsedAddresses, hint: hint);

Future<ProtonExchangeRate> getExchangeRate(
        {required FiatCurrency fiatCurrency, int? time, dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetExchangeRate(
        fiatCurrency: fiatCurrency, time: time, hint: hint);

Future<String> getLatestEventId({dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetLatestEventId(hint: hint);

Future<List<ProtonEvent>> collectEvents(
        {required String latestEventId, dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiCollectEvents(
        latestEventId: latestEventId, hint: hint);

Future<List<ProtonContactEmails>> getContacts({dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetContacts(hint: hint);

Future<List<ProtonAddress>> getProtonAddress({dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetProtonAddress(hint: hint);

Future<WalletAccount> addEmailAddress(
        {required String walletId,
        required String walletAccountId,
        required String addressId,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiAddEmailAddress(
        walletId: walletId,
        walletAccountId: walletAccountId,
        addressId: addressId,
        hint: hint);

Future<WalletAccount> removeEmailAddress(
        {required String walletId,
        required String walletAccountId,
        required String addressId,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiRemoveEmailAddress(
        walletId: walletId,
        walletAccountId: walletAccountId,
        addressId: addressId,
        hint: hint);

Future<WalletBitcoinAddress> updateBitcoinAddress(
        {required String walletId,
        required String walletAccountId,
        required String walletAccountBitcoinAddressId,
        required BitcoinAddress bitcoinAddress,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiUpdateBitcoinAddress(
        walletId: walletId,
        walletAccountId: walletAccountId,
        walletAccountBitcoinAddressId: walletAccountBitcoinAddressId,
        bitcoinAddress: bitcoinAddress,
        hint: hint);

Future<List<WalletBitcoinAddress>> addBitcoinAddresses(
        {required String walletId,
        required String walletAccountId,
        required List<BitcoinAddress> bitcoinAddresses,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiAddBitcoinAddresses(
        walletId: walletId,
        walletAccountId: walletAccountId,
        bitcoinAddresses: bitcoinAddresses,
        hint: hint);

Future<EmailIntegrationBitcoinAddress> lookupBitcoinAddress(
        {required String email, dynamic hint}) =>
    RustLib.instance.api
        .crateApiProtonApiLookupBitcoinAddress(email: email, hint: hint);

Future<List<WalletBitcoinAddress>> getWalletBitcoinAddress(
        {required String walletId,
        required String walletAccountId,
        int? onlyRequest,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetWalletBitcoinAddress(
        walletId: walletId,
        walletAccountId: walletAccountId,
        onlyRequest: onlyRequest,
        hint: hint);

Future<int> getBitcoinAddressLatestIndex(
        {required String walletId,
        required String walletAccountId,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetBitcoinAddressLatestIndex(
        walletId: walletId, walletAccountId: walletAccountId, hint: hint);

Future<List<WalletTransaction>> getWalletTransactions(
        {required String walletId,
        String? walletAccountId,
        List<String>? hashedTxids,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetWalletTransactions(
        walletId: walletId,
        walletAccountId: walletAccountId,
        hashedTxids: hashedTxids,
        hint: hint);

Future<WalletTransaction> createWalletTransactions(
        {required String walletId,
        required String walletAccountId,
        required String transactionId,
        required String hashedTransactionId,
        String? label,
        String? exchangeRateId,
        String? transactionTime,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiCreateWalletTransactions(
        walletId: walletId,
        walletAccountId: walletAccountId,
        transactionId: transactionId,
        hashedTransactionId: hashedTransactionId,
        label: label,
        exchangeRateId: exchangeRateId,
        transactionTime: transactionTime,
        hint: hint);

Future<WalletTransaction> updateWalletTransactionLabel(
        {required String walletId,
        required String walletAccountId,
        required String walletTransactionId,
        required String label,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiUpdateWalletTransactionLabel(
        walletId: walletId,
        walletAccountId: walletAccountId,
        walletTransactionId: walletTransactionId,
        label: label,
        hint: hint);

Future<void> deleteWalletTransactions(
        {required String walletId,
        required String walletAccountId,
        required String walletTransactionId,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiDeleteWalletTransactions(
        walletId: walletId,
        walletAccountId: walletAccountId,
        walletTransactionId: walletTransactionId,
        hint: hint);

Future<String> broadcastRawTransaction(
        {required String signedTransactionHex,
        required String walletId,
        required String walletAccountId,
        String? label,
        String? exchangeRateId,
        String? transactionTime,
        String? addressId,
        String? subject,
        String? body,
        dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiBroadcastRawTransaction(
        signedTransactionHex: signedTransactionHex,
        walletId: walletId,
        walletAccountId: walletAccountId,
        label: label,
        exchangeRateId: exchangeRateId,
        transactionTime: transactionTime,
        addressId: addressId,
        subject: subject,
        body: body,
        hint: hint);

Future<List<AllKeyAddressKey>> getAllPublicKeys(
        {required String email, required int internalOnly, dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiGetAllPublicKeys(
        email: email, internalOnly: internalOnly, hint: hint);

Future<bool> isValidToken({dynamic hint}) =>
    RustLib.instance.api.crateApiProtonApiIsValidToken(hint: hint);
