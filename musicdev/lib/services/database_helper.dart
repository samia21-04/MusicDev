import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _database;

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await getDatabase();
    return _database!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'adaptive_focus.db');

    final db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            mood TEXT,
            task_type TEXT,
            energy_level INTEGER,
            duration_mins INTEGER,
            created_at TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE productivity_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id INTEGER,
            focus_minutes INTEGER,
            distraction_count INTEGER,
            notes TEXT,
            FOREIGN KEY (session_id) REFERENCES sessions(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE presets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            sounds TEXT,
            mood TEXT,
            pomodoro_mins INTEGER,
            break_mins INTEGER
          )
        ''');
      },
    );

    return db;
  }

  // ---------------- SESSIONS ----------------

  Future<int> insertSession(Map<String, dynamic> session) async {
    final db = await database;
    return await db.insert('sessions', session);
  }

  Future<List<Map<String, dynamic>>> getAllSessions() async {
    final db = await database;
    return await db.query('sessions', orderBy: 'created_at DESC');
  }

  Future<int> deleteSession(int id) async {
    final db = await database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---------------- PRODUCTIVITY LOGS ----------------

  Future<int> insertProductivityLog(Map<String, dynamic> log) async {
    final db = await database;
    return await db.insert('productivity_logs', log);
  }

  Future<List<Map<String, dynamic>>> getLogsForSession(int sessionId) async {
    final db = await database;
    return await db.query(
      'productivity_logs',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<int> deleteProductivityLog(int id) async {
    final db = await database;
    return await db.delete(
      'productivity_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---------------- PRESETS ----------------

  Future<int> insertPreset(Map<String, dynamic> preset) async {
    final db = await database;
    return await db.insert('presets', preset);
  }

  Future<List<Map<String, dynamic>>> getAllPresets() async {
    final db = await database;
    return await db.query('presets');
  }

  Future<int> deletePreset(int id) async {
    final db = await database;
    return await db.delete(
      'presets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}