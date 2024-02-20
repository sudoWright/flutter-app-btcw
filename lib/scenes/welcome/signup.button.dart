import 'package:flutter/material.dart';
import 'package:wallet/helper/bdk/mnemonic.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/channels/platform.channel.dart';
import 'package:wallet/rust/bdk/types.dart';
import 'package:flutter_gen/gen_l10n/locale.dart';

var count = 1;

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              NativeViewSwitcher.switchToNativeLogin();
            },
            child: Text(
              S.of(context).login.toUpperCase(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            logger.d("api.publishMessage(message: LoginAndSignupBtn clicked);");
            var mnemonic = await Mnemonic.create(WordCount.words12);
            logger.d(mnemonic.asString());
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber, elevation: 0),
          child: Text(
            S.of(context).signup.toUpperCase(),
            style: const TextStyle(color: Colors.lightBlue),
          ),
        ),
      ],
    );
  }
}
