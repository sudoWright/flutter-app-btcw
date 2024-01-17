import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet/helper/logger.dart';

class SecureStorageHelper {
  static FlutterSecureStorage? storage;
  static bool _initialized = false;

  static AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  static IOSOptions getIOSOptions() => const IOSOptions();

  static MacOsOptions getMacOsOptions() => const MacOsOptions();

  static WindowsOptions getWindowsOptions() => const WindowsOptions();

  static bool isPlatformSupported() {
    return true;
  }

  static void init() {
    if (!isPlatformSupported()) {
      return;
    }
    if (!_initialized) {
      _initialized = true;
      if (Platform.isAndroid) {
        storage = FlutterSecureStorage(aOptions: getAndroidOptions());
      } else if (Platform.isIOS) {
        storage = FlutterSecureStorage(iOptions: getIOSOptions());
      } else if (Platform.isMacOS) {
        storage = FlutterSecureStorage(mOptions: getMacOsOptions());
      } else if (Platform.isWindows) {
        storage = FlutterSecureStorage(wOptions: getWindowsOptions());
      } else {
        storage = const FlutterSecureStorage();
      }
    }
  }

  static Future<void> set(String key_, String value_) async {
    await storage!.write(key: key_, value: value_);
  }

  static Future<String> get(String key_) async {
    String value = await storage!.read(key: key_) ?? "";
    return value;
  }

  static Future<void> deleteAll() async {
    if (Platform.isWindows) {
      logger.w("Windows not support to deleteAll secure storage");
      return;
    }
    await storage!.deleteAll();
  }
}
