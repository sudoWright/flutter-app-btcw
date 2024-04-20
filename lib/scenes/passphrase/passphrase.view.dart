import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet/components/alert.warning.dart';
import 'package:wallet/components/button.v5.dart';
import 'package:wallet/components/onboarding/content.dart';
import 'package:wallet/components/textfield.text.v2.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/constants/sizedbox.dart';
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart';
import 'package:wallet/scenes/passphrase/passphrase.viewmodel.dart';
import 'package:wallet/scenes/core/view.dart';
import 'package:wallet/theme/theme.font.dart';
import 'package:wallet/l10n/generated/locale.dart';

class SetupPassPhraseView extends ViewBase<SetupPassPhraseViewModel> {
  SetupPassPhraseView(SetupPassPhraseViewModel viewModel)
      : super(viewModel, const Key("SetupPassPhraseView"));

  @override
  Widget buildWithViewModel(BuildContext context,
      SetupPassPhraseViewModel viewModel, ViewSize viewSize) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: viewModel.isAddingPassPhrase
            ? buildAddPassPhrase(context, viewModel, viewSize)
            : buildMain(context, viewModel, viewSize));
  }

  Widget buildAddPassPhrase(BuildContext context,
      SetupPassPhraseViewModel viewModel, ViewSize viewSize) {
    return SingleChildScrollView(
        child: Stack(children: [
      Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBoxes.box20,
                Text(S.of(context).your_passphrase_optional,
                    style: FontManager.titleHeadline(ProtonColors.textNorm),
                    textAlign: TextAlign.center),
                SizedBoxes.box8,
                Text(
                  S.of(context).for_additional_security_you_can_use_passphrase_,
                  style: FontManager.body1Median(ProtonColors.textNorm),
                  textAlign: TextAlign.center,
                ),
                SizedBoxes.box24,
                AlertWarning(
                    content:
                        S.of(context).store_your_passphrase_at_safe_location_,
                    width: MediaQuery.of(context).size.width),
                SizedBoxes.box24,
                TextFieldTextV2(
                  labelText: S.of(context).passphrase_label,
                  textController: viewModel.passphraseTextController,
                  myFocusNode: FocusNode(),
                  validation: (String _) {
                    return "";
                  },
                  isPassword: true,
                ),
                SizedBoxes.box24,
                TextFieldTextV2(
                  labelText: S.of(context).confirm_passphrase_label,
                  textController: viewModel.passphraseTextConfirmController,
                  myFocusNode: FocusNode(),
                  validation: (String _) {
                    return "";
                  },
                  isPassword: true,
                ),
              ])),
      AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ProtonColors.textNorm),
          onPressed: () {
            viewModel.updateState(false);
          },
        ),
      ),
      Container(
          padding: const EdgeInsets.only(bottom: 50),
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 40, right: 40),
          height: MediaQuery.of(context).size.height,
          // AppBar default height is 56
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonV5(
                    onPressed: () {
                      if (viewModel.checkPassphrase()) {
                        this.viewModel.updateDB();
                        viewModel.move(ViewIdentifiers.setupReady);
                      } else {
                        var snackBar = SnackBar(
                          content: Text(S.of(context).passphrase_are_not_match),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    text: S.of(context).save_passphrase_button,
                    width: MediaQuery.of(context).size.width,
                    backgroundColor: ProtonColors.protonBlue,
                    textStyle: FontManager.body1Median(ProtonColors.white),
                    height: 48),
              ]))
    ]));
  }

  Widget buildMain(BuildContext context, SetupPassPhraseViewModel viewModel,
      ViewSize viewSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          color: ProtonColors.backgroundSecondary,
          child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 7,
                  bottom: MediaQuery.of(context).size.height / 7),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 100.0,
                ),
                child: SvgPicture.asset(
                  'assets/images/wallet_creation/passphrase_icon.svg',
                  fit: BoxFit.contain,
                ),
              )),
        ),
        Container(
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          child: OnboardingContent(
              totalPages: 2,
              currentPage: 2,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              title: S.of(context).your_passphrase_optional,
              content:
                  S.of(context).for_additional_security_you_can_use_passphrase_,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFieldTextV2(
                      labelText: S.of(context).wallet_name,
                      textController: viewModel.nameTextController,
                      myFocusNode: viewModel.walletNameFocusNode,
                      validation: (String _) {
                        return "";
                      },
                    )),
                SizedBoxes.box12,
                ButtonV5(
                    onPressed: () async {
                      EasyLoading.show(
                          status: "creating wallet..",
                          maskType: EasyLoadingMaskType.black);
                      await this.viewModel.updateDB();
                      EasyLoading.dismiss();
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) {
                          if (route.settings.name == null) {
                            return false;
                          }
                          return route.settings.name ==
                              "[<'HomeNavigationView'>]";
                        });
                      }
                    },
                    text: S.of(context).continue_without_passphrase_button,
                    width: MediaQuery.of(context).size.width,
                    backgroundColor: ProtonColors.protonBlue,
                    textStyle: FontManager.body1Median(ProtonColors.white),
                    height: 48),
                SizedBoxes.box12,
                ButtonV5(
                    onPressed: () {
                      viewModel.updateState(true);
                    },
                    text: S.of(context).yes_use_a_passphrase_button,
                    width: MediaQuery.of(context).size.width,
                    backgroundColor: ProtonColors.white,
                    borderColor: ProtonColors.protonBlue,
                    textStyle: FontManager.body1Median(ProtonColors.protonBlue),
                    height: 48),
              ]),
        ),
      ],
    );
  }
}
