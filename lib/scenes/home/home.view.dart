import 'package:flutter/material.dart';
import 'package:wallet/components/button.v5.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart';
import 'package:wallet/scenes/home/home.viewmodel.dart';

class HomeView extends ViewBase<HomeViewModel> {
  HomeView(HomeViewModel viewModel) : super(viewModel, const Key("HomeView"));

  @override
  Widget buildWithViewModel(
      BuildContext context, HomeViewModel viewModel, ViewSize viewSize) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              const Text("Balance",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  )),
              const Text("1000000000 Sat",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  )),
              const Text("\$30 USD",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                  )),
              const SizedBox(
                height: 10,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        viewModel.coordinator
                            .move(ViewIdentifiers.send, context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D4AFF),
                          elevation: 0),
                      child: const Text(
                        "Send",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.coordinator
                            .move(ViewIdentifiers.receive, context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D4AFF),
                          elevation: 0),
                      child: const Text(
                        "Receive",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ]),
              const SizedBox(height: 20),
              const Text("----------------IF no wallet----------------"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  viewModel.coordinator
                      .move(ViewIdentifiers.setupOnboard, context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D4AFF), elevation: 0),
                child: const Text(
                  "Create Wallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: viewModel.updateStringValue,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D4AFF), elevation: 0),
                child: const Text(
                  "Import Wallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // BottomSheet
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D4AFF), elevation: 0),
                child: const Text(
                  "Backup Wallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const ButtonV5(
                height: 100,
                width: 100,
                text: "This",
              ),
              const SizedBox(height: 20),
            ]),
      ),
    );
  }
}
