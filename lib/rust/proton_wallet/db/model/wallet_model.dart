// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class WalletModel {
  final int id;
  final String name;
  final int passphrase;
  final String publicKey;
  final int imported;
  final int priority;
  final int status;
  final int type;
  final int createTime;
  final int modifyTime;
  final String userId;
  final String walletId;
  final int accountCount;
  final double balance;
  final String? fingerprint;
  final int showWalletRecovery;
  final int migrationRequired;

  const WalletModel({
    required this.id,
    required this.name,
    required this.passphrase,
    required this.publicKey,
    required this.imported,
    required this.priority,
    required this.status,
    required this.type,
    required this.createTime,
    required this.modifyTime,
    required this.userId,
    required this.walletId,
    required this.accountCount,
    required this.balance,
    this.fingerprint,
    required this.showWalletRecovery,
    required this.migrationRequired,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      passphrase.hashCode ^
      publicKey.hashCode ^
      imported.hashCode ^
      priority.hashCode ^
      status.hashCode ^
      type.hashCode ^
      createTime.hashCode ^
      modifyTime.hashCode ^
      userId.hashCode ^
      walletId.hashCode ^
      accountCount.hashCode ^
      balance.hashCode ^
      fingerprint.hashCode ^
      showWalletRecovery.hashCode ^
      migrationRequired.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          passphrase == other.passphrase &&
          publicKey == other.publicKey &&
          imported == other.imported &&
          priority == other.priority &&
          status == other.status &&
          type == other.type &&
          createTime == other.createTime &&
          modifyTime == other.modifyTime &&
          userId == other.userId &&
          walletId == other.walletId &&
          accountCount == other.accountCount &&
          balance == other.balance &&
          fingerprint == other.fingerprint &&
          showWalletRecovery == other.showWalletRecovery &&
          migrationRequired == other.migrationRequired;
}
