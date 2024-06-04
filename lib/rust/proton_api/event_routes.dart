// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'contacts.dart';
import 'exchange_rate.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'user_settings.dart';
import 'wallet.dart';
import 'wallet_account.dart';
import 'wallet_settings.dart';

class ContactEmailEvent {
  final String id;
  final int action;
  final ProtonContactEmails? contactEmail;

  const ContactEmailEvent({
    required this.id,
    required this.action,
    this.contactEmail,
  });

  @override
  int get hashCode => id.hashCode ^ action.hashCode ^ contactEmail.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactEmailEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          action == other.action &&
          contactEmail == other.contactEmail;
}

class ProtonEvent {
  final int code;
  final String eventId;
  final int refresh;
  final int more;
  final List<ContactEmailEvent>? contactEmailEvents;
  final List<WalletEvent>? walletEvents;
  final List<WalletAccountEvent>? walletAccountEvents;
  final List<WalletKeyEvent>? walletKeyEvents;
  final List<WalletSettingsEvent>? walletSettingEvents;
  final List<WalletTransactionEvent>? walletTransactionEvents;
  final ApiUserSettings? walletUserSettings;

  const ProtonEvent({
    required this.code,
    required this.eventId,
    required this.refresh,
    required this.more,
    this.contactEmailEvents,
    this.walletEvents,
    this.walletAccountEvents,
    this.walletKeyEvents,
    this.walletSettingEvents,
    this.walletTransactionEvents,
    this.walletUserSettings,
  });

  @override
  int get hashCode =>
      code.hashCode ^
      eventId.hashCode ^
      refresh.hashCode ^
      more.hashCode ^
      contactEmailEvents.hashCode ^
      walletEvents.hashCode ^
      walletAccountEvents.hashCode ^
      walletKeyEvents.hashCode ^
      walletSettingEvents.hashCode ^
      walletTransactionEvents.hashCode ^
      walletUserSettings.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProtonEvent &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          eventId == other.eventId &&
          refresh == other.refresh &&
          more == other.more &&
          contactEmailEvents == other.contactEmailEvents &&
          walletEvents == other.walletEvents &&
          walletAccountEvents == other.walletAccountEvents &&
          walletKeyEvents == other.walletKeyEvents &&
          walletSettingEvents == other.walletSettingEvents &&
          walletTransactionEvents == other.walletTransactionEvents &&
          walletUserSettings == other.walletUserSettings;
}

class WalletAccountEvent {
  final String id;
  final int action;
  final ApiWalletAccount? walletAccount;

  const WalletAccountEvent({
    required this.id,
    required this.action,
    this.walletAccount,
  });

  @override
  int get hashCode => id.hashCode ^ action.hashCode ^ walletAccount.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAccountEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          action == other.action &&
          walletAccount == other.walletAccount;
}

class WalletEvent {
  final String id;
  final int action;
  final ApiWallet? wallet;

  const WalletEvent({
    required this.id,
    required this.action,
    this.wallet,
  });

  @override
  int get hashCode => id.hashCode ^ action.hashCode ^ wallet.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          action == other.action &&
          wallet == other.wallet;
}

class WalletKeyEvent {
  final String id;
  final int action;
  final ApiWalletKey? walletKey;

  const WalletKeyEvent({
    required this.id,
    required this.action,
    this.walletKey,
  });

  @override
  int get hashCode => id.hashCode ^ action.hashCode ^ walletKey.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletKeyEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          action == other.action &&
          walletKey == other.walletKey;
}

class WalletSettingsEvent {
  final String id;
  final int action;
  final ApiWalletSettings? walletSettings;

  const WalletSettingsEvent({
    required this.id,
    required this.action,
    this.walletSettings,
  });

  @override
  int get hashCode => id.hashCode ^ action.hashCode ^ walletSettings.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletSettingsEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          action == other.action &&
          walletSettings == other.walletSettings;
}

class WalletTransactionEvent {
  final String id;
  final int action;
  final WalletTransaction? walletTransaction;

  const WalletTransactionEvent({
    required this.id,
    required this.action,
    this.walletTransaction,
  });

  @override
  int get hashCode =>
      id.hashCode ^ action.hashCode ^ walletTransaction.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletTransactionEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          action == other.action &&
          walletTransaction == other.walletTransaction;
}
