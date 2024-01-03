import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/scenes/app/app.view.dart';
import 'package:wallet/scenes/app/app.viewmodel.dart';
import 'package:wallet/scenes/core/coordinator.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/core/viewmodel.dart';
import 'package:wallet/scenes/core/view.navigator.dart';
import '../../constants/constants.dart';
import '../welcome/newuser.coordinator.dart';
import '../welcome/welcome.coordinator.dart';

class AppCoordinator extends Coordinator {
  late ViewBase widget;

  @override
  void end() {}

  @override
  ViewBase<ViewModel> move(NavigationIdentifier to, BuildContext context) {
    throw UnimplementedError();
  }

  @override
  ViewBase<ViewModel> start({Map<String, String> params = const {}}) {
    // check cache status

    // if cache is empty, show welcome screen

    // if cache is not empty, show login screen
    ViewBase view = WelcomeCoordinator().start();
    var viewModel = AppViewModelImpl(
      this,
    );
    widget = AppView(
      viewModel,
      view,
    );
    return widget;
  }

  Future<ViewBase<ViewModel>> startWithNewUser() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    bool _hasShow = _preferences.getBool(spHasShowNewUserPage) ?? false;
    ViewBase view;
    if (_hasShow){
      view = WelcomeCoordinator().start();
    } else {
      view = NewUserCoordinator().start();
    }
    var viewModel = AppViewModelImpl(
      this,
    );
    widget = AppView(
      viewModel,
      view,
    );
    return widget;
  }
}
