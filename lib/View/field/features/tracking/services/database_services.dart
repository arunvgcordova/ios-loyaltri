import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  static const activeWorkKey = 'active_work';

  DatabaseService._init();

  /// Thread-safe database getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tracking_sessions.db');
    await _createSyncStateTable(_database!);
    await _dropLegacyTables(_database!);
    return _database!;
  }

  Future<void> _createSyncStateTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_state (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  /// Route, activity, and run tables belonged to the old on-device map.
  /// The live route is the track-v2 session, so those tables are removed.
  /// An open work visit is kept as a sync_state flag before the drop.
  Future<void> _dropLegacyTables(Database db) async {
    final legacy = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'activity_sessions'",
    );
    if (legacy.isNotEmpty) {
      try {
        final openWork = await db.query(
          'activity_sessions',
          columns: ['id'],
          where: 'is_active = ? AND activity = ?',
          whereArgs: [1, 'Start Work'],
          limit: 1,
        );
        if (openWork.isNotEmpty) {
          final existing = await db.query(
            'sync_state',
            where: 'key = ?',
            whereArgs: [activeWorkKey],
            limit: 1,
          );
          if (existing.isEmpty) {
            await db.insert('sync_state', {
              'key': activeWorkKey,
              'value': '1',
            });
          }
        }
      } catch (e) {
        log('[DatabaseService] no legacy work session to keep: $e');
      }
    }

    await db.execute('DROP TABLE IF EXISTS route_points');
    await db.execute('DROP TABLE IF EXISTS activity_sessions');
    await db.execute('DROP TABLE IF EXISTS tracking_runs');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {}

  Future<void> _createDB(Database db, int version) async {}

  Future<bool> hasActiveWork() async {
    return (await getSyncState(activeWorkKey)) == '1';
  }

  Future<void> setActiveWork(bool active) async {
    await setSyncState(activeWorkKey, active ? '1' : '0');
  }

  Future<String?> getSyncState(String key) async {
    final db = await database;
    final maps = await db.query(
      'sync_state',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  Future<void> setSyncState(String key, String value) async {
    final db = await database;
    await db.insert('sync_state', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearSyncState({bool keepShift = false}) async {
    final db = await database;
    final kept = <String, String>{};
    if (keepShift) {
      for (final key in ['v2_session_id', 'v2_session_employee']) {
        final value = await getSyncState(key);
        if (value != null && value.isNotEmpty) kept[key] = value;
      }
    }
    await db.delete('sync_state');
    for (final entry in kept.entries) {
      await setSyncState(entry.key, entry.value);
    }
  }

  Future<void> saveCachedCompanySettings(String jsonStr) async {
    await setSyncState('company_settings', jsonStr);
  }

  Future<String?> getCachedCompanySettings() async {
    return await getSyncState('company_settings');
  }

  Future<void> clearAllDatabase() async {
    log('Tracking deleted ---------------- [DatabaseService] started.');
    try {
      await clearSyncState(keepShift: true);
      log('Tracking deleted ---------------- [DatabaseService] sync state cleared.');
    } catch (e) {
      log('Tracking deleted ---------------- [DatabaseService] Error clearing database: $e');
    }
  }
}
