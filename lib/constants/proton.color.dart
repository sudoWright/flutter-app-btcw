import 'package:flutter/material.dart';

class ProtonColors {
  // default light theme
  static Color interactionNorm = const Color(0xFF6D4AFF);
  static Color white = Colors.white;
  static Color clear = Colors.transparent;
  static Color textNorm = const Color(0xFF0C0C14);
  static Color backgroundBlack = const Color(0xFF000000);
  static Color primaryColor = const Color(0xFF0E0E0E);
  static Color textWeak = const Color(0xFF535964);
  static Color textHint = const Color(0xFF999693);
  static Color iconWeak = const Color(0xFF706D6B);
  static Color wMajor1 = const Color(0xFFDEDBD9);
  static Color nMajor1 = const Color(0xFF6243E6);
  static Color backgroundSecondary = const Color(0xFFF5F4F2);
  static Color backgroundProton = const Color(0xFFF3F5F6);
  static Color alertWaning = const Color(0xFFF78400);
  static Color alertWaningBackground = const Color(0x19FF9900);
  static Color signalSuccess = const Color(0xFF1EA885);
  static Color signalError = const Color(0xFFE32B6D);
  static Color accentSlateblue = const Color(0xFF415DF0);
  static Color mailIntegrationBox = const Color(0xFFEDEAFB);
  static Color transactionNoteBackground = const Color(0x44D0D7E4);

  static Color surfaceLight = const Color(0xFFFBFBFB);
  static Color surfaceTagText = const Color(0xFFFEFEFE);

  static Color protonBlue = const Color(0XFF767DFF);
  static Color protonBrandLighten30 = const Color(0XFFE0E2FF);
  static Color protonShades20 = const Color(0XFFE6E8EC);
  static Color protonBlueAlpha20 = const Color(0X22767DFF);
  static Color protonGrey = const Color(0XFFD9DDE1);
  static Color homepageProgressBarBackground =
      const Color.fromARGB(51, 255, 255, 255);
  static Color drawerBackground = const Color(0xFF222247);
  static Color drawerBackgroundHighlight = const Color(0x2AFFFFFF);
  static Color drawerButtonTextColor = const Color(0xFF222247);
  static Color drawerButtonBackground = const Color(0xFF44448F);
  static Color drawerWalletPlus = const Color(0xFF7B57FC);

  static Color drawerWalletBackground1 = const Color.fromARGB(41, 255, 196, 131);
  static Color drawerWalletTextColor1 = const Color.fromARGB(255, 255, 196, 131);

  static Color orange1Text = const Color(0xffff8902);
  static Color orange1Background = const Color(0x48ffc483);
  static Color pink1Text = const Color(0xffeb8dd6);
  static Color pink1Background = const Color(0x48eb8dd6);
  static Color purple1Text = const Color(0xff9c89ff);
  static Color purple1Background = const Color(0x489c89ff);
  static Color blue1Text = const Color(0xff66b6ff);
  static Color blue1Background = const Color(0x4866b6ff);
  static Color yellow1Text = const Color(0xffFFC483);
  static Color yellow1Background = const Color(0x88FFC483);
  static Color green1Text = const Color(0xff5fc88f);
  static Color green1Background = const Color(0x485fc88f);

  static void updateLightTheme() {
    interactionNorm = const Color(0xFF6D4AFF);
    white = Colors.white;
    clear = Colors.transparent;
    backgroundBlack = const Color(0xFF000000);
    primaryColor = const Color(0xFF0E0E0E);
    textNorm = const Color(0xFF0C0C14);
    textWeak = const Color(0xFF535964);
    textHint = const Color(0xFF999693);
    iconWeak = const Color(0xFF706D6B);
    wMajor1 = const Color(0xFFDEDBD9);
    nMajor1 = const Color(0xFF6243E6);
    backgroundSecondary = const Color(0xFFF5F4F2);
    backgroundProton = const Color(0xFFF3F5F6);
    alertWaning = const Color(0xFFF78400);
    alertWaningBackground = const Color(0x19FF9900);
    signalSuccess = const Color(0xFF1EA885);
    signalError = const Color(0xFFE32B6D);
    accentSlateblue = const Color(0xFF415DF0);
    mailIntegrationBox = const Color(0xFFEDEAFB);

    surfaceLight = const Color(0xFFFBFBFB);
    surfaceTagText = const Color(0xFFFEFEFE);

    protonBlue = const Color(0XFF767DFF);
    homepageProgressBarBackground = const Color.fromARGB(51, 255, 255, 255);
  }

  static void updateDarkTheme() {
    interactionNorm = const Color(0xFF6D4AFF);
    white = Colors.white;
    clear = Colors.transparent;
    textNorm = const Color(0xFFF3F3EB);
    backgroundBlack = const Color(0xFFFFFFFF);
    primaryColor = const Color(0xFFF1F1F1);
    textWeak = const Color(0xFF8F9294);
    textHint = const Color(0xFF66696C);
    iconWeak = const Color(0xFF8F9294);
    wMajor1 = const Color(0xFF212424);
    nMajor1 = const Color(0xFF6243E6);
    backgroundSecondary = const Color(0xFF0A0B0D);
    backgroundProton = const Color(0xFF1D1D1D);
    alertWaning = const Color(0xFFF78400);
    alertWaningBackground = const Color(0x19FF9900);
    signalSuccess = const Color(0xFF1EA885);
    signalError = const Color(0xFFE32B6D);
    accentSlateblue = const Color(0xFF415DF0);
    mailIntegrationBox = const Color(0x12151504);

    surfaceLight = const Color(0x04040404);
    surfaceTagText = const Color(0x01010101);
  }
}
