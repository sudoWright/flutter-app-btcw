// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'exchange_rate.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'user_settings.dart';
import 'wallet_settings.dart';

class ApiWallet {
  final String id;

  /// Name of the wallet
  final String name;

  /// 0 if the wallet is created with Proton Wallet
  final int isImported;

  /// Priority of the wallet (0 is main wallet)
  final int priority;

  /// 1 is onchain, 2 is lightning
  final int type;

  /// 1 if the wallet has a passphrase. We don't store it but clients need to
  /// request on first wallet access.
  final int hasPassphrase;

  /// 1 means disabled
  final int status;

  /// Wallet mnemonic encrypted with the WalletKey, in base64 format
  final String? mnemonic;
  final String? fingerprint;

  /// Wallet master public key encrypted with the WalletKey, in base64 format.
  /// Only allows fetching coins owned by wallet, no spending allowed.
  final String? publicKey;

  const ApiWallet({
    required this.id,
    required this.name,
    required this.isImported,
    required this.priority,
    required this.type,
    required this.hasPassphrase,
    required this.status,
    this.mnemonic,
    this.fingerprint,
    this.publicKey,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      isImported.hashCode ^
      priority.hashCode ^
      type.hashCode ^
      hasPassphrase.hashCode ^
      status.hashCode ^
      mnemonic.hashCode ^
      fingerprint.hashCode ^
      publicKey.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiWallet &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isImported == other.isImported &&
          priority == other.priority &&
          type == other.type &&
          hasPassphrase == other.hasPassphrase &&
          status == other.status &&
          mnemonic == other.mnemonic &&
          fingerprint == other.fingerprint &&
          publicKey == other.publicKey;
}

class ApiWalletBitcoinAddress {
  final String id;
  final String walletId;
  final String walletAccountId;
  final int fetched;
  final int used;
  final String? bitcoinAddress;
  final String? bitcoinAddressSignature;
  final int? bitcoinAddressIndex;

  const ApiWalletBitcoinAddress({
    required this.id,
    required this.walletId,
    required this.walletAccountId,
    required this.fetched,
    required this.used,
    this.bitcoinAddress,
    this.bitcoinAddressSignature,
    this.bitcoinAddressIndex,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      walletId.hashCode ^
      walletAccountId.hashCode ^
      fetched.hashCode ^
      used.hashCode ^
      bitcoinAddress.hashCode ^
      bitcoinAddressSignature.hashCode ^
      bitcoinAddressIndex.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiWalletBitcoinAddress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          walletId == other.walletId &&
          walletAccountId == other.walletAccountId &&
          fetched == other.fetched &&
          used == other.used &&
          bitcoinAddress == other.bitcoinAddress &&
          bitcoinAddressSignature == other.bitcoinAddressSignature &&
          bitcoinAddressIndex == other.bitcoinAddressIndex;
}

class ApiWalletData {
  final ApiWallet wallet;
  final ApiWalletKey walletKey;
  final ApiWalletSettings walletSettings;

  const ApiWalletData({
    required this.wallet,
    required this.walletKey,
    required this.walletSettings,
  });

  @override
  int get hashCode =>
      wallet.hashCode ^ walletKey.hashCode ^ walletSettings.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiWalletData &&
          runtimeType == other.runtimeType &&
          wallet == other.wallet &&
          walletKey == other.walletKey &&
          walletSettings == other.walletSettings;
}

class ApiWalletKey {
  final String walletId;
  final String userKeyId;
  final String walletKey;
  final String walletKeySignature;

  const ApiWalletKey({
    required this.walletId,
    required this.userKeyId,
    required this.walletKey,
    required this.walletKeySignature,
  });

  @override
  int get hashCode =>
      walletId.hashCode ^
      userKeyId.hashCode ^
      walletKey.hashCode ^
      walletKeySignature.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiWalletKey &&
          runtimeType == other.runtimeType &&
          walletId == other.walletId &&
          userKeyId == other.userKeyId &&
          walletKey == other.walletKey &&
          walletKeySignature == other.walletKeySignature;
}

class BitcoinAddress {
  final String bitcoinAddress;
  final String bitcoinAddressSignature;
  final int bitcoinAddressIndex;

  const BitcoinAddress({
    required this.bitcoinAddress,
    required this.bitcoinAddressSignature,
    required this.bitcoinAddressIndex,
  });

  @override
  int get hashCode =>
      bitcoinAddress.hashCode ^
      bitcoinAddressSignature.hashCode ^
      bitcoinAddressIndex.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BitcoinAddress &&
          runtimeType == other.runtimeType &&
          bitcoinAddress == other.bitcoinAddress &&
          bitcoinAddressSignature == other.bitcoinAddressSignature &&
          bitcoinAddressIndex == other.bitcoinAddressIndex;
}

class CreateWalletReq {
  final String name;
  final int isImported;
  final int type;
  final int hasPassphrase;
  final String userKeyId;
  final String walletKey;
  final String? mnemonic;
  final String? publicKey;
  final String? fingerprint;
  final String walletKeySignature;

  /// Flag that indicates the wallet is created from auto creation. 0 for no,
  /// 1 for yes
  final int? isAutoCreated;

  const CreateWalletReq({
    required this.name,
    required this.isImported,
    required this.type,
    required this.hasPassphrase,
    required this.userKeyId,
    required this.walletKey,
    this.mnemonic,
    this.publicKey,
    this.fingerprint,
    required this.walletKeySignature,
    this.isAutoCreated,
  });

  @override
  int get hashCode =>
      name.hashCode ^
      isImported.hashCode ^
      type.hashCode ^
      hasPassphrase.hashCode ^
      userKeyId.hashCode ^
      walletKey.hashCode ^
      mnemonic.hashCode ^
      publicKey.hashCode ^
      fingerprint.hashCode ^
      walletKeySignature.hashCode ^
      isAutoCreated.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateWalletReq &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          isImported == other.isImported &&
          type == other.type &&
          hasPassphrase == other.hasPassphrase &&
          userKeyId == other.userKeyId &&
          walletKey == other.walletKey &&
          mnemonic == other.mnemonic &&
          publicKey == other.publicKey &&
          fingerprint == other.fingerprint &&
          walletKeySignature == other.walletKeySignature &&
          isAutoCreated == other.isAutoCreated;
}

class EmailIntegrationBitcoinAddress {
  final String? bitcoinAddress;
  final String? bitcoinAddressSignature;

  const EmailIntegrationBitcoinAddress({
    this.bitcoinAddress,
    this.bitcoinAddressSignature,
  });

  @override
  int get hashCode =>
      bitcoinAddress.hashCode ^ bitcoinAddressSignature.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailIntegrationBitcoinAddress &&
          runtimeType == other.runtimeType &&
          bitcoinAddress == other.bitcoinAddress &&
          bitcoinAddressSignature == other.bitcoinAddressSignature;
}

enum TransactionType {
  notSend,
  protonToProtonSend,
  protonToProtonReceive,
  externalSend,
  externalReceive,
  unsupported,
  ;
}

class WalletTransaction {
  final String id;
  final TransactionType? type;
  final String walletId;
  final String? walletAccountId;
  final String? label;
  final String transactionId;
  final String transactionTime;
  final int isSuspicious;
  final int isPrivate;
  final ProtonExchangeRate? exchangeRate;
  final String? hashedTransactionId;
  final String? subject;
  final String? body;
  final String? sender;
  final String? tolist;

  const WalletTransaction({
    required this.id,
    this.type,
    required this.walletId,
    this.walletAccountId,
    this.label,
    required this.transactionId,
    required this.transactionTime,
    required this.isSuspicious,
    required this.isPrivate,
    this.exchangeRate,
    this.hashedTransactionId,
    this.subject,
    this.body,
    this.sender,
    this.tolist,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      walletId.hashCode ^
      walletAccountId.hashCode ^
      label.hashCode ^
      transactionId.hashCode ^
      transactionTime.hashCode ^
      isSuspicious.hashCode ^
      isPrivate.hashCode ^
      exchangeRate.hashCode ^
      hashedTransactionId.hashCode ^
      subject.hashCode ^
      body.hashCode ^
      sender.hashCode ^
      tolist.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletTransaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          walletId == other.walletId &&
          walletAccountId == other.walletAccountId &&
          label == other.label &&
          transactionId == other.transactionId &&
          transactionTime == other.transactionTime &&
          isSuspicious == other.isSuspicious &&
          isPrivate == other.isPrivate &&
          exchangeRate == other.exchangeRate &&
          hashedTransactionId == other.hashedTransactionId &&
          subject == other.subject &&
          body == other.body &&
          sender == other.sender &&
          tolist == other.tolist;
}
