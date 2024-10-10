import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet/constants/env.dart';
import 'package:wallet/helper/dbhelper.dart';
import 'package:wallet/helper/user.agent.dart';
import 'package:wallet/managers/api.service.manager.dart';
import 'package:wallet/managers/manager.dart';
import 'package:wallet/managers/preferences/preferences.manager.dart';
import 'package:wallet/managers/providers/address.keys.provider.dart';
import 'package:wallet/managers/providers/bdk.transaction.data.provider.dart';
import 'package:wallet/managers/providers/blockinfo.data.provider.dart';
import 'package:wallet/managers/providers/connectivity.provider.dart';
import 'package:wallet/managers/providers/contacts.data.provider.dart';
import 'package:wallet/managers/providers/exclusive.invite.data.provider.dart';
import 'package:wallet/managers/providers/gateway.data.provider.dart';
import 'package:wallet/managers/providers/local.bitcoin.address.provider.dart';
import 'package:wallet/managers/providers/price.graph.data.provider.dart';
import 'package:wallet/managers/providers/proton.address.provider.dart';
import 'package:wallet/managers/providers/proton.email.address.provider.dart';
import 'package:wallet/managers/providers/receive.address.data.provider.dart';
import 'package:wallet/managers/providers/server.transaction.data.provider.dart';
import 'package:wallet/managers/providers/unleash.data.provider.dart';
import 'package:wallet/managers/providers/user.data.provider.dart';
import 'package:wallet/managers/providers/user.settings.data.provider.dart';
import 'package:wallet/managers/providers/wallet.data.provider.dart';
import 'package:wallet/managers/providers/wallet.keys.provider.dart';
import 'package:wallet/managers/providers/wallet.mnemonic.provider.dart';
import 'package:wallet/managers/providers/wallet.name.provider.dart';
import 'package:wallet/managers/providers/wallet.passphrase.provider.dart';
import 'package:wallet/managers/secure.storage/secure.storage.manager.dart';
import 'package:wallet/managers/users/user.manager.dart';
import 'package:wallet/managers/wallet/wallet.manager.dart';
import 'package:wallet/models/drift/db/app.database.dart';
import 'package:wallet/models/drift/user.keys.queries.dart';
import 'package:wallet/models/drift/users.queries.dart';
import 'package:wallet/models/drift/wallet.user.settings.queries.dart';
import 'package:wallet/models/wallet.keys.store.dart';

/// data state
abstract class DataState extends Equatable {}

class DataInitial extends DataState {
  @override
  List<Object?> get props => [];
}

abstract class DataLoading extends DataState {}

abstract class DataLoaded extends DataState {
  final String data;

  DataLoaded(this.data);
}

abstract class DataCreated extends DataState {}

enum UpdateType {
  inserted,
  updated,
  deleted,
}

class DataUpdated<T> extends DataState {
  final T updatedData;

  DataUpdated(this.updatedData);

  @override
  List<Object?> get props => [updatedData];
}

class SelectedWalletUpdated extends DataState {
  @override
  List<Object?> get props => [];
}

abstract class DataDeleted extends DataState {}

class DataError extends DataState {
  final String message;

  DataError(this.message);

  @override
  List<Object?> get props => [message];
}

///
abstract class DataEvent extends Equatable {}

abstract class DataLoad extends DataEvent {}

abstract class DataCreate extends DataEvent {}

abstract class DataUpdate extends DataEvent {}

abstract class DataDelete extends DataEvent {}

class DirectEmitEvent extends DataEvent {
  final DataState state;

  DirectEmitEvent(this.state);

  @override
  List<Object?> get props => [state];
}

abstract class DataProvider extends Bloc<DataEvent, DataState> {
  DataProvider() : super(DataInitial()) {
    on<DirectEmitEvent>((event, emit) => emit(event.state));
  }

  void emitState(DataState state) {
    add(DirectEmitEvent(state));
  }

  Future<void> clear();

  /// reload data
  Future<void> reload();
}

class DataProviderManager extends Manager {
  final SecureStorageManager storage;
  final PreferencesManager shared;
  final ProtonApiServiceManager apiServiceManager;
  final AppDatabase dbConnection;
  final UserManager userManager;
  final ApiEnv apiEnv;

  late UserDataProvider userDataProvider;
  late WalletsDataProvider walletDataProvider;
  late WalletPassphraseProvider walletPassphraseProvider;
  late WalletKeysProvider walletKeysProvider;
  late ContactsDataProvider contactsDataProvider;
  late UserSettingsDataProvider userSettingsDataProvider;
  late AddressKeyProvider addressKeyProvider;
  late ServerTransactionDataProvider serverTransactionDataProvider;
  late BDKTransactionDataProvider bdkTransactionDataProvider;
  late LocalBitcoinAddressDataProvider localBitcoinAddressDataProvider;
  late GatewayDataProvider gatewayDataProvider;
  late ProtonAddressProvider protonAddressProvider;
  late BlockInfoDataProvider blockInfoDataProvider;
  late UnleashDataProvider unleashDataProvider;
  late ExclusiveInviteDataProvider exclusiveInviteDataProvider;
  late ProtonEmailAddressProvider protonEmailAddressProvider;
  late ConnectivityProvider connectivityProvider;
  late PriceGraphDataProvider priceGraphDataProvider;
  late ReceiveAddressDataProvider receiveAddressDataProvider;

  ///
  late WalletMnemonicProvider walletMnemonicProvider;
  late WalletNameProvider walletNameProvider;

  // TODO(improve): this is not good
  late WalletManager walletManager;

  DataProviderManager(
    this.apiEnv,
    this.storage,
    this.shared,
    this.apiServiceManager,
    this.dbConnection,
    this.userManager,
  );

  @override
  Future<void> login(String userID) async {
    //
    userDataProvider = UserDataProvider(
      apiServiceManager.getApiService().getProtonUserClient(),
      UserQueries(dbConnection),
      UserKeysQueries(dbConnection),
    );
    //
    walletPassphraseProvider = WalletPassphraseProvider(storage);
    // wallets and accounts
    walletDataProvider = WalletsDataProvider(
      storage,
      DBHelper.walletDao!,
      DBHelper.accountDao!,
      DBHelper.addressDao!,
      apiServiceManager.getApiService().getWalletClient(),
      // TODO(fix): put selected wallet server id here
      "",
      // TODO(fix): put selected wallet account server id here
      "",
      userID,
    );
    //
    walletKeysProvider = WalletKeysProvider(
      userManager,
      WalletKeyStore(storage),
      apiServiceManager.getApiService().getWalletClient(),
    );
    //
    contactsDataProvider = ContactsDataProvider(
      apiServiceManager.getApiService().getProtonContactsClient(),
      DBHelper.contactsDao!,
      userID,
    );
    //
    userSettingsDataProvider = UserSettingsDataProvider(
      userID,
      WalletUserSettingsQueries(dbConnection),
      apiServiceManager.getApiService().getSettingsClient(),
      shared,
    );
    // on ramp gateway
    gatewayDataProvider = GatewayDataProvider(
      apiServiceManager.getApiService().getOnRampGatewayClient(),
    );

    addressKeyProvider = AddressKeyProvider(
      userManager,
      apiServiceManager.getApiService().getProtonEmailAddrClient(),
    );

    serverTransactionDataProvider = ServerTransactionDataProvider(
        apiServiceManager.getApiService().getWalletClient(),
        DBHelper.walletDao!,
        DBHelper.accountDao!,
        DBHelper.exchangeRateDao!,
        DBHelper.transactionDao!,
        userManager.userID);

    bdkTransactionDataProvider = BDKTransactionDataProvider(
      DBHelper.accountDao!,
      apiServiceManager.getApiService(),
      shared,
      walletManager,
    );

    localBitcoinAddressDataProvider = LocalBitcoinAddressDataProvider(
      DBHelper.walletDao!,
      DBHelper.accountDao!,
      DBHelper.bitcoinAddressDao!,
      userID,
      walletManager,
    );

    // balanceDataProvider = BalanceDataProvider(
    //   DBHelper.accountDao!,
    // );

    protonAddressProvider = ProtonAddressProvider(
      DBHelper.addressDao!,
    );

    blockInfoDataProvider = BlockInfoDataProvider(
      apiServiceManager.getApiService().getBlockClient(),
    );

    exclusiveInviteDataProvider = ExclusiveInviteDataProvider(
      apiServiceManager.getApiService().getInviteClient(),
    );

    protonEmailAddressProvider = ProtonEmailAddressProvider();

    connectivityProvider = ConnectivityProvider();

    priceGraphDataProvider = PriceGraphDataProvider(
      apiServiceManager.getApiService().getPriceGraphClient(),
    );

    receiveAddressDataProvider = ReceiveAddressDataProvider(
      apiServiceManager.getApiService().getBitcoinAddrClient(),
      apiServiceManager.getApiService().getWalletClient(),
      walletDataProvider,
    );

    walletMnemonicProvider = WalletMnemonicProvider(
      walletKeysProvider,
      walletDataProvider,
      userManager,
    );

    walletNameProvider = WalletNameProvider(
      walletKeysProvider,
      DBHelper.accountDao!,
      DBHelper.walletDao!,
    );

    final userAgent = UserAgent();
    final uid = userManager.userInfo.sessionId;
    final accessToken = userManager.userInfo.accessToken;
    unleashDataProvider = UnleashDataProvider(
      apiEnv,
      await userAgent.appVersion,
      await userAgent.ua,
      uid,
      accessToken,
    );
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init() async {}

  @override
  Future<void> logout() async {
    await userDataProvider.clear();
    await walletDataProvider.clear();
    await walletPassphraseProvider.clear();
    await walletKeysProvider.clear();
    await contactsDataProvider.clear();
    await userSettingsDataProvider.clear();
    await addressKeyProvider.clear();
    await serverTransactionDataProvider.clear();
    await bdkTransactionDataProvider.clear();
    await localBitcoinAddressDataProvider.clear();
    await gatewayDataProvider.clear();
    await protonAddressProvider.clear();
    await blockInfoDataProvider.clear();
    await unleashDataProvider.clear();
    await exclusiveInviteDataProvider.clear();
    await protonEmailAddressProvider.clear();
    await connectivityProvider.clear();
    await priceGraphDataProvider.clear();
    await receiveAddressDataProvider.clear();
    await walletMnemonicProvider.clear();
    await walletNameProvider.clear();
  }

  @override
  Future<void> reload() async {
    await userDataProvider.reload();
    await walletDataProvider.reload();
    await walletPassphraseProvider.reload();
    await walletKeysProvider.reload();
    await contactsDataProvider.reload();
    await userSettingsDataProvider.reload();
    await addressKeyProvider.reload();
    await serverTransactionDataProvider.reload();
    await bdkTransactionDataProvider.reload();
    await localBitcoinAddressDataProvider.reload();
    await gatewayDataProvider.reload();
    await protonAddressProvider.reload();
    await blockInfoDataProvider.reload();
    await unleashDataProvider.reload();
    await exclusiveInviteDataProvider.reload();
    await protonEmailAddressProvider.reload();
    await connectivityProvider.reload();
    await priceGraphDataProvider.reload();
    await receiveAddressDataProvider.reload();
    await walletMnemonicProvider.reload();
    await walletNameProvider.reload();
  }
}
