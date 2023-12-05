import 'dart:async';

import 'package:wallet/generated/bridge_definitions.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/helper/bdk/mnemonic.dart';
import 'package:wallet/scenes/core/viewmodel.dart';

abstract class HomeViewModel extends ViewModel {
  HomeViewModel(super.coordinator);

  int selectedPage = 0;
  String mnemonicString = 'No Wallet';

  void updateSelected(int index);
  void updateMnemonic(String mnemonic);
  void incrementCounter();
  Future<void> updateStringValue();

  @override
  bool get keepAlive => true;
}

class HomeViewModelImpl extends HomeViewModel {
  HomeViewModelImpl(super.coordinator);

  final datasourceChangedStreamController =
      StreamController<HomeViewModel>.broadcast();
  final selectedSectionChangedController = StreamController<int>.broadcast();

  @override
  void dispose() {
    datasourceChangedStreamController.close();
    selectedSectionChangedController.close();
  }

  @override
  Future<void> loadData() async {
    return;
  }

  @override
  Stream<ViewModel> get datasourceChanged =>
      datasourceChangedStreamController.stream;

  @override
  void updateSelected(int index) {
    selectedPage = index;
    datasourceChangedStreamController.sink.add(this);
  }

  @override
  void updateMnemonic(String mnemonic) {
    mnemonicString = mnemonic;
    datasourceChangedStreamController.sink.add(this);
  }

  @override
  void incrementCounter() {}

  @override
  Future<void> updateStringValue() async {
    var mnemonic = await Mnemonic.create(WordCount.Words12);
    logger.d(mnemonic.asString());
    updateMnemonic(mnemonic.asString());
  }
}
