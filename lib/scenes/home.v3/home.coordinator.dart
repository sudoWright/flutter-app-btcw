import 'package:wallet/scenes/backup.v2/backup.coordinator.dart';
import 'package:wallet/scenes/core/coordinator.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/core/viewmodel.dart';
import 'package:wallet/scenes/debug/websocket.coordinator.dart';
import 'package:wallet/scenes/deletion/deletion.coordinator.dart';
import 'package:wallet/scenes/history/details.coordinator.dart';
import 'package:wallet/scenes/home.v3/home.view.dart';
import 'package:wallet/scenes/home.v3/home.viewmodel.dart';
import 'package:wallet/scenes/receive/receive.coordinator.dart';
import 'package:wallet/scenes/send/send.coordinator.dart';
import 'package:wallet/scenes/settings/mail_integration/maillist.coordinator.dart';
import 'package:wallet/scenes/setup/onboard.coordinator.dart';
import 'package:wallet/scenes/two.factor.auth.disable/two.factor.auth.disable.coordinator.dart';
import 'package:wallet/scenes/two.factor.auth/two.factor.auth.coordinator.dart';
import 'package:wallet/scenes/wallet/wallet.coordinator.dart';
import 'package:wallet/scenes/welcome/welcome.coordinator.dart';

class HomeCoordinator extends Coordinator {
  late ViewBase widget;

  @override
  void end() {}

  void showWallet(int walletID) {
    var view = WalletCoordinator(walletID).start();
    push(view, fullscreenDialog: false);
  }

  void showSetupOnbaord() {
    var view = SetupOnbaordCoordinator().start();
    push(view, fullscreenDialog: true);
  }

  void showSend(int walletID, int accountID) {
    var view = SendCoordinator(walletID, accountID).start();
    push(view, fullscreenDialog: true);
  }

  void showSetupBackup(int walletID) {
    var view = SetupBackupCoordinator(walletID).start();
    push(view, fullscreenDialog: false);
  }

  void showReceive(int walletID, int accountID) {
    var view = ReceiveCoordinator(walletID, accountID).start();
    push(view, fullscreenDialog: true);
  }

  void showWebSocket() {
    var view = WebSocketCoordinator().start();
    push(view, fullscreenDialog: true);
  }

  void showMailList() {
    var view = MailListCoordinator().start();
    push(view, fullscreenDialog: true);
  }

  void showWalletDeletion(int walletID) {
    var view = WalletDeletionCoordinator(walletID).start();
    push(view, fullscreenDialog: true);
  }

  void showHistoryDetails(int walletID, int accountID, String txID) {
    var view = HistoryDetailCoordinator(walletID, accountID, txID).start();
    push(view);
  }

  void showTwoFactorAuthSetup() {
    var view = TwoFactorAuthCoordinator().start();
    push(view);
  }

  void showTwoFactorAuthDisable() {
    var view = TwoFactorAuthDisableCoordinator().start();
    push(view);
  }

  void logout() {
    var view = WelcomeCoordinator().start();
    pushReplacement(view);
  }

  @override
  ViewBase<ViewModel> start() {
    var viewModel = HomeViewModelImpl(
      this,
    );
    widget = HomeView(
      viewModel,
    );
    return widget;
  }
}
