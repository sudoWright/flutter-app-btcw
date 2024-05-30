import 'dart:async';

import 'package:wallet/helper/firebase_messaging_helper.dart';
import 'package:wallet/helper/local_auth.dart';
import 'package:wallet/helper/local_notification.dart';
import 'package:wallet/managers/api.service.manager.dart';
import 'package:wallet/managers/manager.factory.dart';
import 'package:wallet/scenes/app/app.coordinator.dart';
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart';
import 'package:wallet/scenes/core/viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/constants/app.config.dart';
import 'package:wallet/helper/dbhelper.dart';
import 'package:wallet/managers/channels/platform.channel.manager.dart';
import 'package:wallet/managers/event.loop.manager.dart';
import 'package:wallet/managers/secure.storage/secure.storage.dart';
import 'package:wallet/managers/secure.storage/secure.storage.manager.dart';
import 'package:wallet/managers/users/user.manager.dart';
import 'package:wallet/managers/wallet/proton.wallet.manager.dart';
import 'package:wallet/managers/wallet/wallet.manager.dart';

abstract class AppViewModel extends ViewModel<AppCoordinator> {
  AppViewModel(super.coordinator);
}

class AppViewModelImpl extends AppViewModel {
  final ManagerFactory serviceManager;

  AppViewModelImpl(super.coordinator, this.serviceManager);
  final datasourceChangedStreamController =
      StreamController<AppViewModel>.broadcast();

  @override
  Stream<ViewModel> get datasourceChanged =>
      datasourceChangedStreamController.stream;

  @override
  void dispose() {
    datasourceChangedStreamController.close();
  }

  @override
  Future<void> loadData() async {
    /// read env
    final AppConfig config = appConfig;
    final apiEnv = config.apiEnv;

    /// setup local services
    LocalNotification.init();
    FirebaseMessagingHelper.init();
    LocalAuth.init();

    /// platform channel manager
    var platform = PlatformChannelManager(config.apiEnv);
    await platform.init();
    serviceManager.register(platform);

    /// notify native initalized
    platform.initalNativeApiEnv(apiEnv);

    /// persistent storage
    var storage = SecureStorageManager(storage: SecureStorage());
    serviceManager.register(storage);

    /// shared preferences
    var shared = await SharedPreferences.getInstance();

    /// sqlite db
    await DBHelper.init();

    /// networking
    var apiServiceManager = ProtonApiServiceManager(apiEnv, storage: storage);
    await apiServiceManager.init();
    serviceManager.register(apiServiceManager);

    /// user manager
    var userManager = UserManager(storage, shared, apiEnv, apiServiceManager);
    serviceManager.register(userManager);

    /// proton wallet manager
    var protonWallet = ProtonWalletManager(storage: storage);
    serviceManager.register(protonWallet);

    // TODO:: fix me
    WalletManager.apiEnv = apiEnv;
    WalletManager.userManager = userManager;
    WalletManager.protonWallet = protonWallet;

    /// event loop
    serviceManager.register(EventLoop(protonWallet, userManager));

    if (await userManager.sessionExists()) {
      await userManager.tryRestoreUserInfo();
      coordinator.showHome(apiEnv);
    } else {
      coordinator.showWelcome(apiEnv);
    }
  }

  @override
  Future<void> move(NavID to) async {}
}
