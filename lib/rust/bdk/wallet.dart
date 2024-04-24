// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.28.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
import 'types.dart';
part 'wallet.freezed.dart';

@freezed
sealed class DatabaseConfig with _$DatabaseConfig {
  const factory DatabaseConfig.memory() = DatabaseConfig_Memory;

  ///Simple key-value embedded database based on sled
  const factory DatabaseConfig.sqlite({
    required SqliteDbConfiguration config,
  }) = DatabaseConfig_Sqlite;
}

/// Unspent outputs of this wallet
class LocalUtxo {
  /// Reference to a transaction output
  final OutPoint outpoint;

  ///Transaction output
  final TxOut txout;

  ///Whether this UTXO is spent or not
  final bool isSpent;
  final KeychainKind keychain;

  const LocalUtxo({
    required this.outpoint,
    required this.txout,
    required this.isSpent,
    required this.keychain,
  });

  @override
  int get hashCode =>
      outpoint.hashCode ^ txout.hashCode ^ isSpent.hashCode ^ keychain.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalUtxo &&
          runtimeType == other.runtimeType &&
          outpoint == other.outpoint &&
          txout == other.txout &&
          isSpent == other.isSpent &&
          keychain == other.keychain;
}

/// Options for a software signer
///
/// Adjust the behavior of our software signers and the way a transaction is finalized
class SignOptions {
  /// Whether the provided transaction is a multi-sig transaction
  final bool isMultiSig;

  /// Whether the signer should trust the `witness_utxo`, if the `non_witness_utxo` hasn't been
  /// provided
  ///
  /// Defaults to `false` to mitigate the "SegWit bug" which should trick the wallet into
  /// paying a fee larger than expected.
  ///
  /// Some wallets, especially if relatively old, might not provide the `non_witness_utxo` for
  /// SegWit transactions in the PSBT they generate: in those cases setting this to `true`
  /// should correctly produce a signature, at the expense of an increased trust in the creator
  /// of the PSBT.
  ///
  /// For more details see: <https://blog.trezor.io/details-of-firmware-updates-for-trezor-one-version-1-9-1-and-trezor-model-t-version-2-3-1-1eba8f60f2dd>
  final bool trustWitnessUtxo;

  /// Whether the wallet should assume a specific height has been reached when trying to finalize
  /// a transaction
  ///
  /// The wallet will only "use" a timelock to satisfy the spending policy of an input if the
  /// timelock height has already been reached. This option allows overriding the "current height" to let the
  /// wallet use timelocks in the future to spend a coin.
  final int? assumeHeight;

  /// Whether the signer should use the `sighash_type` set in the PSBT when signing, no matter
  /// what its value is
  ///
  /// Defaults to `false` which will only allow signing using `SIGHASH_ALL`.
  final bool allowAllSighashes;

  /// Whether to remove partial signatures from the PSBT inputs while finalizing PSBT.
  ///
  /// Defaults to `true` which will remove partial signatures during finalization.
  final bool removePartialSigs;

  /// Whether to try finalizing the PSBT after the inputs are signed.
  ///
  /// Defaults to `true` which will try finalizing PSBT after inputs are signed.
  final bool tryFinalize;

  /// Whether we should try to sign a taproot transaction with the taproot internal key
  /// or not. This option is ignored if we're signing a non-taproot PSBT.
  ///
  /// Defaults to `true`, i.e., we always try to sign with the taproot internal key.
  final bool signWithTapInternalKey;

  /// Whether we should grind ECDSA signature to ensure signing with low r
  /// or not.
  /// Defaults to `true`, i.e., we always grind ECDSA signature to sign with low r.
  final bool allowGrinding;

  const SignOptions({
    required this.isMultiSig,
    required this.trustWitnessUtxo,
    this.assumeHeight,
    required this.allowAllSighashes,
    required this.removePartialSigs,
    required this.tryFinalize,
    required this.signWithTapInternalKey,
    required this.allowGrinding,
  });

  @override
  int get hashCode =>
      isMultiSig.hashCode ^
      trustWitnessUtxo.hashCode ^
      assumeHeight.hashCode ^
      allowAllSighashes.hashCode ^
      removePartialSigs.hashCode ^
      tryFinalize.hashCode ^
      signWithTapInternalKey.hashCode ^
      allowGrinding.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignOptions &&
          runtimeType == other.runtimeType &&
          isMultiSig == other.isMultiSig &&
          trustWitnessUtxo == other.trustWitnessUtxo &&
          assumeHeight == other.assumeHeight &&
          allowAllSighashes == other.allowAllSighashes &&
          removePartialSigs == other.removePartialSigs &&
          tryFinalize == other.tryFinalize &&
          signWithTapInternalKey == other.signWithTapInternalKey &&
          allowGrinding == other.allowGrinding;
}

///Configuration type for a SqliteDatabase database
class SqliteDbConfiguration {
  ///Main directory of the db
  final String path;

  const SqliteDbConfiguration({
    required this.path,
  });

  @override
  int get hashCode => path.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqliteDbConfiguration &&
          runtimeType == other.runtimeType &&
          path == other.path;
}
