import 'package:wallet/managers/channels/native.view.channel.dart';
import 'package:wallet/constants/env.dart';
import 'package:wallet/managers/user.manager.dart';
import 'package:wallet/scenes/core/coordinator.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/core/viewmodel.dart';
import 'package:wallet/scenes/home/navigation.coordinator.dart';
import 'package:wallet/scenes/signin/signin.coordinator.dart';
import 'package:wallet/scenes/welcome/welcome.view.dart';
import 'package:wallet/scenes/welcome/welcome.viewmodel.dart';

class WelcomeCoordinator extends Coordinator {
  late ViewBase widget;
  final NativeViewChannel nativeViewChannel;

  WelcomeCoordinator({required this.nativeViewChannel});

  @override
  void end() {}

  void showNativeSignin(ApiEnv env) {
    nativeViewChannel.switchToNativeLogin(env);
  }

  void showNativeSignup(ApiEnv env) {
    nativeViewChannel.switchToNativeSignup(env);
  }

  void showHome(ApiEnv env) {
    var view = HomeNavigationCoordinator(env).start();
    pushReplacement(view);
  }

  void showFlutterSignin(ApiEnv env) {
    var view = SigninCoordinator().start();
    showDialog1(view);
  }

  @override
  ViewBase<ViewModel> start() {
    var userManager = serviceManager.get<UserManager>();
    var viewModel = WelcomeViewModelImpl(this, nativeViewChannel, userManager);
    widget = WelcomeView(
      viewModel,
    );
    return widget;
  }
}
