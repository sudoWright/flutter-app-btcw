// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import '../../proton_api/auth_credential.dart';
import '../../proton_api/wallet.dart';
import '../../proton_api/wallet_settings.dart';
import '../bdk_wallet/blockchain.dart';
import '../errors.dart';
import 'address_client.dart';
import 'bitcoin_address_client.dart';
import 'block_client.dart';
import 'discovery_content_client.dart';
import 'email_integration_client.dart';
import 'event_client.dart';
import 'exchange_rate_client.dart';
import 'invite_client.dart';
import 'onramp_gateway_client.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'price_graph_client.dart';
import 'proton_contacts_client.dart';
import 'proton_email_addr_client.dart';
import 'proton_settings_client.dart';
import 'proton_users_client.dart';
import 'settings_client.dart';
import 'transaction_client.dart';
import 'wallet_auth_store.dart';
import 'wallet_client.dart';

// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonAPIService>>
abstract class ProtonApiService implements RustOpaqueInterface {
  AddressClient getAddressClient();

  ArcProtonApiService getArc();

  BitcoinAddressClient getBitcoinAddrClient();

  BlockClient getBlockClient();

  DiscoveryContentClient getDiscoveryContentClient();

  EmailIntegrationClient getEmailIntegrationClient();

  EventClient getEventClient();

  ExchangeRateClient getExchangeRateClient();

  InviteClient getInviteClient();

  OnRampGatewayClient getOnRampGatewayClient();

  PriceGraphClient getPriceGraphClient();

  ContactsClient getProtonContactsClient();

  ProtonEmailAddressClient getProtonEmailAddrClient();

  ProtonSettingsClient getProtonSettingsClient();

  ProtonUsersClient getProtonUserClient();

  SettingsClient getSettingsClient();

  TransactionClient getTransactionClient();

  WalletClient getWalletClient();

  /// clients
  Future<List<ApiWalletData>> getWallets();

  Future<AuthCredential> login(
      {required String username, required String password});

  Future<void> logout();

  factory ProtonApiService(
          {required String env,
          required String appVersion,
          required String userAgent,
          required ProtonWalletAuthStore store}) =>
      RustLib.instance.api
          .crateApiApiServiceProtonApiServiceProtonApiServiceNew(
              env: env,
              appVersion: appVersion,
              userAgent: userAgent,
              store: store);

  Future<void> setProtonApi();

  Future<void> updateAuth(
      {required String uid,
      required String access,
      required String refresh,
      required List<String> scopes});
}
