// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../bdk/key.dart';
import '../bdk_common/error.dart';
import '../bdk_common/word_count.dart';
import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::rust_async::RwLock<BdkMnemonic>>
@sealed
class BdkMnemonic extends RustOpaque {
  BdkMnemonic.dcoDecode(List<dynamic> wire)
      : super.dcoDecode(wire, _kStaticData);

  BdkMnemonic.sseDecode(int ptr, int externalSizeOnNative)
      : super.sseDecode(ptr, externalSizeOnNative, _kStaticData);

  static final _kStaticData = RustArcStaticData(
    rustArcIncrementStrongCount:
        RustLib.instance.api.rust_arc_increment_strong_count_BdkMnemonic,
    rustArcDecrementStrongCount:
        RustLib.instance.api.rust_arc_decrement_strong_count_BdkMnemonic,
    rustArcDecrementStrongCountPtr:
        RustLib.instance.api.rust_arc_decrement_strong_count_BdkMnemonicPtr,
  );
}

class RustMnemonic {
  final Mnemonic inner;

  const RustMnemonic({
    required this.inner,
  });

  /// Returns the Mnemonic as a string.
  Future<String> asString({dynamic hint}) =>
      RustLib.instance.api.rustMnemonicAsString(
        that: this,
      );

  Future<List<String>> asWords({dynamic hint}) =>
      RustLib.instance.api.rustMnemonicAsWords(
        that: this,
      );

  static Future<RustMnemonic> fromString(
          {required String mnemonic, dynamic hint}) =>
      RustLib.instance.api
          .rustMnemonicFromString(mnemonic: mnemonic, hint: hint);

  /// Generates a Mnemonic with a random entropy based on the given word count.
  static Future<RustMnemonic> newRustMnemonic(
          {required WordCount wordCount, dynamic hint}) =>
      RustLib.instance.api.rustMnemonicNew(wordCount: wordCount, hint: hint);

  @override
  int get hashCode => inner.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RustMnemonic &&
          runtimeType == other.runtimeType &&
          inner == other.inner;
}
