import 'dart:convert';
import 'dart:typed_data';

import 'package:proton_crypto/proton_crypto.dart' as proton_crypto;

class AddressKey {
  final String privateKey;
  final String passphrase;

  AddressKey({required this.privateKey, required this.passphrase});

  String decryptBinary(String? binaryEncryptedString) {
    if (binaryEncryptedString != null) {
      Uint8List bytes = proton_crypto.decryptBinary(
          privateKey, passphrase, base64Decode(binaryEncryptedString));
      String? decryptedMessage = utf8.decode(bytes);
      if (decryptedMessage != "null") {
        return decryptedMessage;
      }
    }
    return "";
  }

  String decrypt(String encryptedArmor) {
    return proton_crypto.decrypt(privateKey, passphrase, encryptedArmor);
  }

  String encrypt(String plainText) {
    return proton_crypto.encrypt(privateKey, plainText);
  }

  String encryptBinary(Uint8List data) {
    return base64Encode(proton_crypto.encryptBinary(privateKey, data));
  }
}
