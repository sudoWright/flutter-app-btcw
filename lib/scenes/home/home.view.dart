import 'package:flutter/material.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/home/home.viewmodel.dart';

class HomeView extends ViewBase<HomeViewModel> {
  HomeView(HomeViewModel viewModel) : super(viewModel, const Key("HomeView"));

  @override
  Widget buildWithViewModel(
      BuildContext context, HomeViewModel viewModel, ViewSize viewSize) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Proton Wallet Home"),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: viewModel.updateStringValue,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D4AFF), elevation: 0),
                child: Text(
                  "Create Wallet".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                viewModel.mnemonicString,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
