import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wallet/constants/assets.gen.dart';
import 'package:wallet/constants/colors.gen.dart';
import 'package:wallet/helper/local_toast.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/scenes/signin/signin.viewmodel.dart';

class SigninView extends ViewBase<SigninViewModel> {
  const SigninView(SigninViewModel viewModel)
      : super(viewModel, const Key("WelcomeView"));

  @override
  Widget build(BuildContext context) {
    return buildWelcome(context);
  }

  Widget buildWelcome(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.errorMessage.isNotEmpty) {
        LocalToast.showErrorToast(context, viewModel.errorMessage);
        viewModel.errorMessage = "";
      }
    });
    return AlertDialog(
      title: buildHeader(),
      backgroundColor: ColorName.light10,
      content: buildContentForm(usernameController, passwordController),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Closes the dialog
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () async {
            // Logic for logging in goes here
            // Navigator.of(context).pop(); // Closes the dialog
            EasyLoading.show(
                status: "Loading ...", maskType: EasyLoadingMaskType.black);
            await viewModel.signIn(
                usernameController.text, passwordController.text);
            EasyLoading.dismiss();
          },
          child: const Text('Login'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Container buildContentForm(TextEditingController usernameController,
      TextEditingController passwordController) {
    return Container(
      constraints: const BoxConstraints(minWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: <Widget>[
          const Text(
            "Username or email",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ColorName.weakLight),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          CupertinoTextField.borderless(
            keyboardType: TextInputType.emailAddress,
            controller: usernameController,
            style: const TextStyle(fontSize: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(14.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
          const SizedBox(height: 16),
          const Text(
            "Password",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ColorName.weakLight),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          CupertinoTextField.borderless(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: passwordController,
            style: const TextStyle(fontSize: 16),
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(14.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          ),
        ],
      ),
    );
  }

  Container buildHeader() {
    return Container(
      constraints: const BoxConstraints(minWidth: 340),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const SizedBox(height: 24),
        Assets.images.logos.protonPLogo.svg(),
        const SizedBox(height: 20),
        const Text('Sign in to Proton',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
        const SizedBox(height: 8),
        const Text("Enter your Proton Account details.",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))
      ]),
    );
  }
}
