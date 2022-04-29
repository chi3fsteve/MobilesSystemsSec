import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'data.db');
    final database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      return db
          .execute('CREATE TABLE users(email TEXT PRIMARY KEY, password TEXT)');
    });
    return database;
  }
}
