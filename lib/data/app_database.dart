import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? _database;

Future<Database> get appDatabase async {
  _database ??= await _openDatabase();
  return _database!;
}

Future<Database> _openDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'product_app.db');

  return openDatabase(
    path,
    version: 2,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE products (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          price REAL NOT NULL,
          description TEXT NOT NULL,
          icon_code_point INTEGER NOT NULL,
          image BLOB
        )
      ''');
      await db.execute('''
        CREATE TABLE favorites (
          product_id TEXT PRIMARY KEY,
          FOREIGN KEY (product_id) REFERENCES products (id)
            ON DELETE CASCADE
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE products ADD COLUMN image BLOB');
      }
    },
  );
}
