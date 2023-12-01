import 'package:flutter/material.dart';
import 'package:wallet/generated/bridge_definitions.dart';
import 'package:wallet/helper/mnemonic.dart';
import 'package:wallet/channels/platformchannel.dart';
import 'package:wallet/scenes/home/home.view.dart';

var count = 1;

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              NativeViewSwitcher.switchToNativeView();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return const WalletHomePage(title: 'Flutter Wallet');
              //     },
              //   ),
              // );
            },
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            print("api.publishMessage(message: LoginAndSignupBtn clicked);");
            var mnemonic = await Mnemonic.create(WordCount.Words12);
            print(mnemonic.asString());
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return const WalletHomePage(title: 'Flutter Wallet');
            //     },
            //   ),
            // );
          },
          style: ElevatedButton.styleFrom(primary: Colors.amber, elevation: 0),
          child: Text(
            "Sign Up".toUpperCase(),
            style: const TextStyle(color: Colors.lightBlue),
          ),
        ),
      ],
    );
  }
}
