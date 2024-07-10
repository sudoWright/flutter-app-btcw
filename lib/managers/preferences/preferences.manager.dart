import 'package:wallet/helper/logger.dart';
import 'package:wallet/managers/manager.dart';
import 'package:wallet/managers/preferences/preferences.interface.dart';

typedef Logic = Future<void> Function();

class PreferencesManager implements Manager {
  // storage interface
  final PreferencesInterface storage;

  PreferencesManager(this.storage);

  /// function
  Future<void> deleteAll() async {
    await storage.deleteAll();
  }

  Future<void> checkif(String key, dynamic value, Logic run) async {
    // Get the value
    dynamic checkValue = await storage.read(key);
    // Check if the value is false
    if (checkValue != value) {
      logger.d('Running logic because checkValue $key is not match');
      await run.call();
      await storage.write(key, value);
    }
  }

  Future<dynamic> read(String key) async {
    return await storage.read(key);
  }

  Future<void> write(String key, dynamic value) async {
    await storage.write(key, value);
  }

  @override
  Future<void> dispose() async {}

  @override
  Future<void> init() async {}

  @override
  Future<void> logout() async {
    await deleteAll();
  }

  @override
  Future<void> login(String userID) async {
    // TODO: implement login
    throw UnimplementedError();
  }
}
