import 'package:wallet/managers/api.service.manager.dart';
import 'package:wallet/managers/app.state.manager.dart';
import 'package:wallet/managers/features/proton.recovery/proton.recovery.bloc.dart';
import 'package:wallet/managers/proton.wallet.manager.dart';
import 'package:wallet/managers/providers/data.provider.manager.dart';
import 'package:wallet/scenes/core/coordinator.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/core/viewmodel.dart';
import 'package:wallet/scenes/recovery/recovery.view.dart';
import 'package:wallet/scenes/recovery/recovery.viewmodel.dart';

class RecoveryCoordinator extends Coordinator {
  late ViewBase widget;

  @override
  void end() {}

  @override
  ViewBase<ViewModel> start() {
    final apiServiceManager = serviceManager.get<ProtonApiServiceManager>();
    final dataProviderManager = serviceManager.get<DataProviderManager>();
    final appStateManager = serviceManager.get<AppStateManager>();
    final walletManager = serviceManager.get<ProtonWalletManager>();

    final ProtonRecoveryBloc protonRecoveryBloc = ProtonRecoveryBloc(
      dataProviderManager.userDataProvider,
      appStateManager,
      walletManager.getProtonRecoveryFeature(),
    );

    final viewModel = RecoveryViewModelImpl(
      this,
      protonRecoveryBloc,
      apiServiceManager.getProtonUsersApiClient(),
    );
    widget = RecoveryView(
      viewModel,
    );
    return widget;
  }
}
