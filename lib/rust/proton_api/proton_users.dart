// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class ApiMnemonicUserKey {
  final String id;
  final String privateKey;
  final String salt;

  const ApiMnemonicUserKey({
    required this.id,
    required this.privateKey,
    required this.salt,
  });

  @override
  int get hashCode => id.hashCode ^ privateKey.hashCode ^ salt.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiMnemonicUserKey &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          privateKey == other.privateKey &&
          salt == other.salt;
}

class EmailSettings {
  final String? value;
  final int status;
  final int notify;
  final int reset;

  const EmailSettings({
    this.value,
    required this.status,
    required this.notify,
    required this.reset,
  });

  @override
  int get hashCode =>
      value.hashCode ^ status.hashCode ^ notify.hashCode ^ reset.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailSettings &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          status == other.status &&
          notify == other.notify &&
          reset == other.reset;
}

class FlagsSettings {
  const FlagsSettings();

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlagsSettings && runtimeType == other.runtimeType;
}

class GetAuthInfoResponseBody {
  final int code;
  final String modulus;
  final String serverEphemeral;
  final int version;
  final String salt;
  final String srpSession;
  final TwoFA twoFa;

  const GetAuthInfoResponseBody({
    required this.code,
    required this.modulus,
    required this.serverEphemeral,
    required this.version,
    required this.salt,
    required this.srpSession,
    required this.twoFa,
  });

  @override
  int get hashCode =>
      code.hashCode ^
      modulus.hashCode ^
      serverEphemeral.hashCode ^
      version.hashCode ^
      salt.hashCode ^
      srpSession.hashCode ^
      twoFa.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetAuthInfoResponseBody &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          modulus == other.modulus &&
          serverEphemeral == other.serverEphemeral &&
          version == other.version &&
          salt == other.salt &&
          srpSession == other.srpSession &&
          twoFa == other.twoFa;
}

class GetAuthModulusResponse {
  final int code;
  final String modulus;
  final String modulusId;

  const GetAuthModulusResponse({
    required this.code,
    required this.modulus,
    required this.modulusId,
  });

  @override
  int get hashCode => code.hashCode ^ modulus.hashCode ^ modulusId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetAuthModulusResponse &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          modulus == other.modulus &&
          modulusId == other.modulusId;
}

class HighSecuritySettings {
  final int eligible;
  final int value;

  const HighSecuritySettings({
    required this.eligible,
    required this.value,
  });

  @override
  int get hashCode => eligible.hashCode ^ value.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighSecuritySettings &&
          runtimeType == other.runtimeType &&
          eligible == other.eligible &&
          value == other.value;
}

class MnemonicAuth {
  final int version;
  final String modulusId;
  final String salt;
  final String verifier;

  const MnemonicAuth({
    required this.version,
    required this.modulusId,
    required this.salt,
    required this.verifier,
  });

  @override
  int get hashCode =>
      version.hashCode ^ modulusId.hashCode ^ salt.hashCode ^ verifier.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MnemonicAuth &&
          runtimeType == other.runtimeType &&
          version == other.version &&
          modulusId == other.modulusId &&
          salt == other.salt &&
          verifier == other.verifier;
}

class MnemonicUserKey {
  final String id;
  final String privateKey;

  const MnemonicUserKey({
    required this.id,
    required this.privateKey,
  });

  @override
  int get hashCode => id.hashCode ^ privateKey.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MnemonicUserKey &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          privateKey == other.privateKey;
}

class PasswordSettings {
  const PasswordSettings();

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordSettings && runtimeType == other.runtimeType;
}

class PhoneSettings {
  const PhoneSettings();

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneSettings && runtimeType == other.runtimeType;
}

class ProtonSrpClientProofs {
  final String clientEphemeral;
  final String clientProof;
  final String srpSession;
  final String? twoFactorCode;

  const ProtonSrpClientProofs({
    required this.clientEphemeral,
    required this.clientProof,
    required this.srpSession,
    this.twoFactorCode,
  });

  @override
  int get hashCode =>
      clientEphemeral.hashCode ^
      clientProof.hashCode ^
      srpSession.hashCode ^
      twoFactorCode.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtonSrpClientProofs &&
          runtimeType == other.runtimeType &&
          clientEphemeral == other.clientEphemeral &&
          clientProof == other.clientProof &&
          srpSession == other.srpSession &&
          twoFactorCode == other.twoFactorCode;
}

class ProtonUser {
  final String id;
  final String name;
  final BigInt usedSpace;
  final String currency;
  final int credit;
  final BigInt createTime;
  final BigInt maxSpace;
  final BigInt maxUpload;
  final int role;
  final int private;
  final int subscribed;
  final int services;
  final int delinquent;
  final String? organizationPrivateKey;
  final String email;
  final String displayName;
  final List<ProtonUserKey>? keys;
  final int mnemonicStatus;

  const ProtonUser({
    required this.id,
    required this.name,
    required this.usedSpace,
    required this.currency,
    required this.credit,
    required this.createTime,
    required this.maxSpace,
    required this.maxUpload,
    required this.role,
    required this.private,
    required this.subscribed,
    required this.services,
    required this.delinquent,
    this.organizationPrivateKey,
    required this.email,
    required this.displayName,
    this.keys,
    required this.mnemonicStatus,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      usedSpace.hashCode ^
      currency.hashCode ^
      credit.hashCode ^
      createTime.hashCode ^
      maxSpace.hashCode ^
      maxUpload.hashCode ^
      role.hashCode ^
      private.hashCode ^
      subscribed.hashCode ^
      services.hashCode ^
      delinquent.hashCode ^
      organizationPrivateKey.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      keys.hashCode ^
      mnemonicStatus.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtonUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          usedSpace == other.usedSpace &&
          currency == other.currency &&
          credit == other.credit &&
          createTime == other.createTime &&
          maxSpace == other.maxSpace &&
          maxUpload == other.maxUpload &&
          role == other.role &&
          private == other.private &&
          subscribed == other.subscribed &&
          services == other.services &&
          delinquent == other.delinquent &&
          organizationPrivateKey == other.organizationPrivateKey &&
          email == other.email &&
          displayName == other.displayName &&
          keys == other.keys &&
          mnemonicStatus == other.mnemonicStatus;
}

class ProtonUserKey {
  final String id;
  final int version;
  final String privateKey;
  final String? recoverySecret;
  final String? recoverySecretSignature;
  final String? token;
  final String fingerprint;
  final int primary;
  final int active;

  const ProtonUserKey({
    required this.id,
    required this.version,
    required this.privateKey,
    this.recoverySecret,
    this.recoverySecretSignature,
    this.token,
    required this.fingerprint,
    required this.primary,
    required this.active,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      version.hashCode ^
      privateKey.hashCode ^
      recoverySecret.hashCode ^
      recoverySecretSignature.hashCode ^
      token.hashCode ^
      fingerprint.hashCode ^
      primary.hashCode ^
      active.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtonUserKey &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          version == other.version &&
          privateKey == other.privateKey &&
          recoverySecret == other.recoverySecret &&
          recoverySecretSignature == other.recoverySecretSignature &&
          token == other.token &&
          fingerprint == other.fingerprint &&
          primary == other.primary &&
          active == other.active;
}

class ProtonUserSettings {
  final EmailSettings email;
  final PasswordSettings? password;
  final PhoneSettings? phone;
  final TwoFASettings? twoFa;
  final int news;
  final String locale;
  final int logAuth;
  final String invoiceText;
  final int density;
  final int weekStart;
  final int dateFormat;
  final int timeFormat;
  final int welcome;
  final int welcomeFlag;
  final int earlyAccess;
  final FlagsSettings? flags;
  final ReferralSettings? referral;
  final int deviceRecovery;
  final int telemetry;
  final int crashReports;
  final int hideSidePanel;
  final HighSecuritySettings highSecurity;
  final int sessionAccountRecovery;

  const ProtonUserSettings({
    required this.email,
    this.password,
    this.phone,
    this.twoFa,
    required this.news,
    required this.locale,
    required this.logAuth,
    required this.invoiceText,
    required this.density,
    required this.weekStart,
    required this.dateFormat,
    required this.timeFormat,
    required this.welcome,
    required this.welcomeFlag,
    required this.earlyAccess,
    this.flags,
    this.referral,
    required this.deviceRecovery,
    required this.telemetry,
    required this.crashReports,
    required this.hideSidePanel,
    required this.highSecurity,
    required this.sessionAccountRecovery,
  });

  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      phone.hashCode ^
      twoFa.hashCode ^
      news.hashCode ^
      locale.hashCode ^
      logAuth.hashCode ^
      invoiceText.hashCode ^
      density.hashCode ^
      weekStart.hashCode ^
      dateFormat.hashCode ^
      timeFormat.hashCode ^
      welcome.hashCode ^
      welcomeFlag.hashCode ^
      earlyAccess.hashCode ^
      flags.hashCode ^
      referral.hashCode ^
      deviceRecovery.hashCode ^
      telemetry.hashCode ^
      crashReports.hashCode ^
      hideSidePanel.hashCode ^
      highSecurity.hashCode ^
      sessionAccountRecovery.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtonUserSettings &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          phone == other.phone &&
          twoFa == other.twoFa &&
          news == other.news &&
          locale == other.locale &&
          logAuth == other.logAuth &&
          invoiceText == other.invoiceText &&
          density == other.density &&
          weekStart == other.weekStart &&
          dateFormat == other.dateFormat &&
          timeFormat == other.timeFormat &&
          welcome == other.welcome &&
          welcomeFlag == other.welcomeFlag &&
          earlyAccess == other.earlyAccess &&
          flags == other.flags &&
          referral == other.referral &&
          deviceRecovery == other.deviceRecovery &&
          telemetry == other.telemetry &&
          crashReports == other.crashReports &&
          hideSidePanel == other.hideSidePanel &&
          highSecurity == other.highSecurity &&
          sessionAccountRecovery == other.sessionAccountRecovery;
}

class ReferralSettings {
  const ReferralSettings();

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReferralSettings && runtimeType == other.runtimeType;
}

class SetTwoFaTOTPRequestBody {
  final String totpConfirmation;
  final String totpSharedSecret;

  const SetTwoFaTOTPRequestBody({
    required this.totpConfirmation,
    required this.totpSharedSecret,
  });

  @override
  int get hashCode => totpConfirmation.hashCode ^ totpSharedSecret.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetTwoFaTOTPRequestBody &&
          runtimeType == other.runtimeType &&
          totpConfirmation == other.totpConfirmation &&
          totpSharedSecret == other.totpSharedSecret;
}

class SetTwoFaTOTPResponseBody {
  final int code;
  final List<String> twoFactorRecoveryCodes;
  final ProtonUserSettings userSettings;

  const SetTwoFaTOTPResponseBody({
    required this.code,
    required this.twoFactorRecoveryCodes,
    required this.userSettings,
  });

  @override
  int get hashCode =>
      code.hashCode ^ twoFactorRecoveryCodes.hashCode ^ userSettings.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetTwoFaTOTPResponseBody &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          twoFactorRecoveryCodes == other.twoFactorRecoveryCodes &&
          userSettings == other.userSettings;
}

class TwoFA {
  final int enabled;

  const TwoFA({
    required this.enabled,
  });

  @override
  int get hashCode => enabled.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwoFA &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled;
}

class TwoFASettings {
  final int enabled;
  final int allowed;

  const TwoFASettings({
    required this.enabled,
    required this.allowed,
  });

  @override
  int get hashCode => enabled.hashCode ^ allowed.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwoFASettings &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          allowed == other.allowed;
}

class UpdateMnemonicSettingsRequestBody {
  final List<MnemonicUserKey> mnemonicUserKeys;
  final String mnemonicSalt;
  final MnemonicAuth mnemonicAuth;

  const UpdateMnemonicSettingsRequestBody({
    required this.mnemonicUserKeys,
    required this.mnemonicSalt,
    required this.mnemonicAuth,
  });

  @override
  int get hashCode =>
      mnemonicUserKeys.hashCode ^ mnemonicSalt.hashCode ^ mnemonicAuth.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateMnemonicSettingsRequestBody &&
          runtimeType == other.runtimeType &&
          mnemonicUserKeys == other.mnemonicUserKeys &&
          mnemonicSalt == other.mnemonicSalt &&
          mnemonicAuth == other.mnemonicAuth;
}
