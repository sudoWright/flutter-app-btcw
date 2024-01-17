import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:wallet/models/database/app.database.dart';

class DBHelper {
  static AppDatabase? _appDatabase;

  static Future<Database> get database async {
    if (_appDatabase != null) {
      return _appDatabase!.db;
    }
    init();
    return _appDatabase!.db;
  }

  static AccountDao? get accountDao {
    if (_appDatabase != null) {
      return _appDatabase!.accountDao;
    }
    return null;
  }

  static WalletDao? get walletDao {
    if (_appDatabase != null) {
      return _appDatabase!.walletDao;
    }
    return null;
  }

  static TransactionDao? get transactionDao {
    if (_appDatabase != null) {
      return _appDatabase!.transactionDao;
    }
    return null;
  }

  static Future<void> init() async {
    _appDatabase = AppDatabase();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int appDatabaseVersion = preferences.getInt("appDatabaseVersion") ?? 1;
    await _appDatabase!.buildDatabase(oldVersion: appDatabaseVersion);
    preferences.setInt("appDatabaseVersion", _appDatabase!.version);
  }

  static Future<void> reset() async {
    // Notice! this method will clean all data in appDatabase, then rebuild tables
    if (_appDatabase != null) {
      _appDatabase!.reset();
    }
  }
}
