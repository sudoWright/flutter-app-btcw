import 'package:flutter/material.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/scenes/core/view.dart';

import 'buybitcoin.viewmodel.dart';

class BuyBitcoinView extends ViewBase<BuyBitcoinViewModel> {
  BuyBitcoinView(BuyBitcoinViewModel viewModel)
      : super(viewModel, const Key("BuyBitcoinView"));

  @override
  Widget buildWithViewModel(
      BuildContext context, BuyBitcoinViewModel viewModel, ViewSize viewSize) {
    return Scaffold(
      backgroundColor: ProtonColors.backgroundProton,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("BuyBitcoinView"),
      ),
      body: const Text("BuyBitcoinView"),
    );
  }
}
