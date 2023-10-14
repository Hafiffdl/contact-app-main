import 'package:sqflite/sqflite.dart';
import 'package:interactive_widget/models/contact_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDB();
    return _database!;
  }

  final String tableName = "contacts";

  Future<Database> _initializeDB() async {
    var db = await openDatabase(
      'contacts_db.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT,
          nomor TEXT,
          selectedDate TEXT,
          selectedColor INTEGER,
          filePath TEXT
        )''');
      },
    );

    return db;
  }

  Future<void> insertContact(ContactModel contactModel) async {
    final Database db = await database;
    await db.insert(tableName, contactModel.toMap());
  }

  Future<List<ContactModel>> getContacts() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(tableName);
    return results.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<ContactModel> getContactById(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return ContactModel.fromMap(results.first);
  }

  Future<void> updateContact(ContactModel contactModel) async {
    final Database db = await database;
    await db.update(
      tableName,
      contactModel.toMap(),
      where: "id = ?",
      whereArgs: [contactModel.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final Database db = await database;
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
