import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/session.dart';
import '../models/preset.dart';
import '../models/productivity_log.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('focus_studio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Sessions table
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        mood TEXT NOT NULL,
        task_type TEXT NOT NULL,
        energy_level INTEGER NOT NULL,
        duration_mins INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Productivity logs table
    await db.execute('''
      CREATE TABLE productivity_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        focus_minutes INTEGER NOT NULL,
        distraction_count INTEGER NOT NULL,
        notes TEXT,
        FOREIGN KEY (session_id) REFERENCES sessions(id)
      )
    ''');

    // Presets table
    await db.execute('''
      CREATE TABLE presets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        sounds TEXT NOT NULL,
        mood TEXT,
        pomodoro_mins INTEGER NOT NULL,
        break_mins INTEGER NOT NULL
      )
    ''');
  }

  // ── SESSION CRUD ──────────────────────────────────────────

  Future<int> createSession(Session session) async {
    final db = await database;
    return await db.insert('sessions', session.toMap());
  }

  Future<List<Session>> getAllSessions() async {
    final db = await database;
    final result = await db.query('sessions', orderBy: 'created_at DESC');
    return result.map((map) => Session.fromMap(map)).toList();
  }

  Future<Session?> getSession(int id) async {
    final db = await database;
    final result = await db.query('sessions', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Session.fromMap(result.first) : null;
  }

  Future<int> updateSession(Session session) async {
    final db = await database;
    return await db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> deleteSession(int id) async {
    final db = await database;
    return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  // ── PRODUCTIVITY LOG CRUD ─────────────────────────────────

  Future<int> createLog(ProductivityLog log) async {
    final db = await database;
    return await db.insert('productivity_logs', log.toMap());
  }

  Future<List<ProductivityLog>> getLogsForSession(int sessionId) async {
    final db = await database;
    final result = await db.query(
      'productivity_logs',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
    return result.map((map) => ProductivityLog.fromMap(map)).toList();
  }

  Future<List<ProductivityLog>> getAllLogs() async {
    final db = await database;
    final result = await db.query('productivity_logs');
    return result.map((map) => ProductivityLog.fromMap(map)).toList();
  }

  Future<int> deleteLog(int id) async {
    final db = await database;
    return await db.delete('productivity_logs', where: 'id = ?', whereArgs: [id]);
  }

  // ── PRESET CRUD ───────────────────────────────────────────

  Future<int> createPreset(Preset preset) async {
    final db = await database;
    return await db.insert('presets', preset.toMap());
  }

  Future<List<Preset>> getAllPresets() async {
    final db = await database;
    final result = await db.query('presets');
    return result.map((map) => Preset.fromMap(map)).toList();
  }

  Future<int> updatePreset(Preset preset) async {
    final db = await database;
    return await db.update(
      'presets',
      preset.toMap(),
      where: 'id = ?',
      whereArgs: [preset.id],
    );
  }

  Future<int> deletePreset(int id) async {
    final db = await database;
    return await db.delete('presets', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}