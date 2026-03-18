import 'package:flutter/material.dart';
import '../models/session.dart';
import '../models/preset.dart';
import '../models/productivity_log.dart';
import '../services/database_service.dart';

class SessionProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  // State variables
  List<Session> _sessions = [];
  List<Preset> _presets = [];
  List<ProductivityLog> _logs = [];
  String _selectedMood = 'Calm';
  int _energyLevel = 3;
  String _selectedTaskType = 'Study';
  bool _isLoading = false;

  // Getters — screens read data through these
  List<Session> get sessions => _sessions;
  List<Preset> get presets => _presets;
  List<ProductivityLog> get logs => _logs;
  String get selectedMood => _selectedMood;
  int get energyLevel => _energyLevel;
  String get selectedTaskType => _selectedTaskType;
  bool get isLoading => _isLoading;

  // ── LOAD DATA ─────────────────────────────────────────────

  Future<void> loadSessions() async {
    _isLoading = true;
    notifyListeners();

    _sessions = await _db.getAllSessions();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPresets() async {
    _presets = await _db.getAllPresets();
    notifyListeners();
  }

  Future<void> loadLogs() async {
    _logs = await _db.getAllLogs();
    notifyListeners();
  }

  // ── SESSION ACTIONS ───────────────────────────────────────

  Future<void> addSession(Session session) async {
    await _db.createSession(session);
    await loadSessions(); // refresh the list
  }

  Future<void> deleteSession(int id) async {
    await _db.deleteSession(id);
    await loadSessions();
  }

  // ── PRESET ACTIONS ────────────────────────────────────────

  Future<void> addPreset(Preset preset) async {
    await _db.createPreset(preset);
    await loadPresets();
  }

  Future<void> deletePreset(int id) async {
    await _db.deletePreset(id);
    await loadPresets();
  }

  // ── LOG ACTIONS ───────────────────────────────────────────

  Future<void> addLog(ProductivityLog log) async {
    await _db.createLog(log);
    await loadLogs();
  }

  // ── UI STATE SETTERS ──────────────────────────────────────
  // These update Home Screen selections and notify listeners

  void setMood(String mood) {
    _selectedMood = mood;
    notifyListeners();
  }

  void setEnergyLevel(int level) {
    _energyLevel = level;
    notifyListeners();
  }

  void setTaskType(String taskType) {
    _selectedTaskType = taskType;
    notifyListeners();
  }
}