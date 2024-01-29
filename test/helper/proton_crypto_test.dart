import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/helper/proton.crypto.test.dart';

void main() {
  group('Proton Crypto functions', () {
    test('encrypt decrypt case 1', () async {
      String userPrivateKey = '''-----BEGIN PGP PRIVATE KEY BLOCK-----
Version: Keybase OpenPGP v2.0.76
Comment: https://keybase.io/crypto

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
81hM+A==
=tMIn
-----END PGP PRIVATE KEY BLOCK-----''';
      String message = "Hello Proton Crypto!";
      String passphrase = "hellopgp";
      String armor =
          encrypt(userPrivateKey.toNativeUtf8(), message.toNativeUtf8());
      String decryptMessage = decrypt(userPrivateKey.toNativeUtf8(),
          passphrase.toNativeUtf8(), armor.toNativeUtf8());
      expect(decryptMessage, equals(message));
    });

    test('encrypt decrypt case 2', () async {
      String userPrivateKey = '''-----BEGIN PGP PRIVATE KEY BLOCK-----

xYYEZbIlGRYJKwYBBAHaRw8BAQdAdgwLi+IULWqS++gRe2dQ3MizLRArYnKS
ObqnhO8lmx7+CQMIylIrAYAm2CTgEg659zXzpjkiKKZy7K/JuNkR2C/vTB5K
CpwWcEFVolPUBGnogZ2FXFbsaT+X4bhtjh3BvzCcZE98w8JCtDmuuO6RVSBV
6c0Zd2lsbCA8d2lsbC5oc3VAcHJvdG9uLmNoPsKMBBAWCgA+BYJlsiUZBAsJ
BwgJkPNpnCHsB1PwAxUICgQWAAIBAhkBApsDAh4BFiEEwbyRkBhFYvxWzS6g
82mcIewHU/AAAPr/AQCYc0O+oIb5TgeRDbHIJTNbqziYbCWgyuxBh8tP4YRw
ugEA2zsKx03i8SHf5D/Vp1gTFcxjd29UEcXsrliNuSmoSwDHiwRlsiUZEgor
BgEEAZdVAQUBAQdAH6YJuedrpyBVOb40Nj+ptgoErSY1O4SL75Kj15HyIXcD
AQgH/gkDCJb3DUJaU++C4Kfqo+7C0EyL7hLP8259PlWlQHO11Z1ZrQQKgjET
LqlQAB80U19xsSzFZbmZ+MH6fZNwniysGCCBDglgS87JRnbk2OO7lZXCeAQY
FgoAKgWCZbIlGQmQ82mcIewHU/ACmwwWIQTBvJGQGEVi/FbNLqDzaZwh7AdT
8AAA9zsBANZH8j8OL7VsYbFE/+E8vN+Hra9iRFO5dP3b8G9BCPydAP46V4hM
DeYE4U0ks7cI9VPmeImOYBNcTOZIqIA2hEniBg==
=/tHc
-----END PGP PRIVATE KEY BLOCK-----''';
      String message = "Test message 2";
      String passphrase = "12345678";
      String armor = '''-----BEGIN PGP MESSAGE-----

wV4D6Ur1q/PBrZ4SAQdApm8uzokGXqEx6ZdyAjpAnkTokFEVtX/HfEEEAY8o
fXsw7silZoz8i8ADeCIoltn9yxeAWFmNuIiVn/W0NS8Tq2X179OQR/J/K2zj
EjOJpeHY0j8B14q+E3Ci5XKAVQiX3hSmN/tiq8fKXx0WIxTl8W9C4GxbCH4Z
S78EDl9lzDq2HRD4mB7Ghh1DJL9aDN8fEaM=
=Md5n
-----END PGP MESSAGE-----''';
      String decryptMessage = decrypt(userPrivateKey.toNativeUtf8(),
          passphrase.toNativeUtf8(), armor.toNativeUtf8());
      expect(decryptMessage, equals(message));
    });
  });
}
