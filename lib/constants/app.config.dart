import 'package:wallet/constants/coin_type.dart';
import 'package:wallet/constants/env.dart';
import 'package:wallet/constants/script_type.dart';
import 'package:wallet/helper/logger.dart';

class AppConfig {
  // use for derivation creation, e.g. m/$ScriptType/$CoinType/$accountIndex
  CoinType coinType;
  // use for derivation creation, e.g. m/$ScriptType/$CoinType/$accountIndex
  ScriptTypeInfo scriptTypeInfo;
  ApiEnv apiEnv;
  String esploraWebpageUrl;
  String esploraApiUrl;
  // TODO:: use this flag to enable / disable test output
  bool testMode;

  ///
  AppConfig({
    required this.coinType,
    required this.scriptTypeInfo,
    required this.apiEnv,
    required this.esploraWebpageUrl,
    required this.esploraApiUrl,
    required this.testMode,
  });

  /// TODO:: conver this to enum
  static void initAppEnv() {
    const environment = String.fromEnvironment('appEnv', defaultValue: 'prod');
    logger.i('App environment: $environment');
    if (environment == 'payment') {
      appConfig = appConfigForPayments;
    } else if (environment == 'atlas') {
      appConfig = appConfigForTestNet;
    } else {
      appConfig = appConfigForProduction;
    }
  }
}

var appConfig = appConfigForProduction;

///predefined app config for test net
final appConfigForTestNet = AppConfig(
    coinType: bitcoinTestnet,
    scriptTypeInfo: ScriptTypeInfo.nativeSegWit,
    apiEnv: ApiEnv.atlas(null),
    esploraWebpageUrl: "https://proton.me/wallet/explorer/testnet/",

    /// use https://blockstream.info as api service since our own esplora service is not public yet
    /// TODO:: change to our own esplora client once it's public
    esploraApiUrl: "https://blockstream.info/testnet/",
    testMode: true);

// payment test
final appConfigForPayments = AppConfig(
    coinType: bitcoinTestnet,
    scriptTypeInfo: ScriptTypeInfo.nativeSegWit,
    apiEnv: payments,
    esploraWebpageUrl: "https://payments.proton.me/wallet/explorer/testnet/",

    /// use https://blockstream.info as api service since our own esplora service is not public yet
    /// TODO:: change to our own esplora client once it's public
    esploraApiUrl: "https://blockstream.info/testnet/",
    testMode: true);

// production and this will be the default
final appConfigForProduction = AppConfig(
    coinType: bitcoin,
    scriptTypeInfo: ScriptTypeInfo.nativeSegWit,
    apiEnv: const ApiEnv.prod(),
    esploraWebpageUrl: "https://proton.me/wallet/explorer/",

    /// use https://blockstream.info as api service since our own esplora service is not public yet
    /// TODO:: change to our own esplora client once it's public
    esploraApiUrl: "https://blockstream.info/",
    testMode: false);
