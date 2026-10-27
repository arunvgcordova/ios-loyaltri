import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/checkIn_model.dart';

class PunchDatabase {
  static final PunchDatabase instance = PunchDatabase._init();

  static Database? _database;

  PunchDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('punch.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    AttendanceCommonWidgets().printF(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const boolType = 'BOOLEAN';
    const intType = 'INTEGER';

    await db.execute('''CREATE TABLE $punchTableName( 
  ${PunchFields.id} $idType, 
  ${PunchFields.employeeId} $textType,
  ${PunchFields.companyId} $textType,
  ${PunchFields.punchDate} $textType,
  ${PunchFields.punchTime} $textType,
  ${PunchFields.punchType} $textType,
  ${PunchFields.punchRemarks} $textType,
  ${PunchFields.punchImage} $textType,
  ${PunchFields.locationName} $textType,
  ${PunchFields.latitude} $textType,
  ${PunchFields.longitude} $textType,
  ${PunchFields.punchState} $textType,
  ${PunchFields.isSynced} $intType
  )''');
  }

  Future<AttendanceCheckModel> create(AttendanceCheckModel punch) async {
    final db = await instance.database;

    final id = await db.insert(punchTableName, punch.toJson());
    return punch.copy(id: id);
  }

  Future<AttendanceCheckModel> readPunchData(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      punchTableName,
      columns: PunchFields.values,
      where: '${PunchFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return AttendanceCheckModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<AttendanceCheckModel>> readAllPunchData() async {
    final db = await instance.database;

    final result = await db.query(punchTableName);

    return result.map((json) => AttendanceCheckModel.fromJson(json)).toList();
  }

  Future<AttendanceCheckModel?> readLastSavedPunch() async {
    final db = await instance.database;

    final result = await db.query(
      punchTableName,
      orderBy: '${PunchFields.id} DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return AttendanceCheckModel.fromJson(result.first);
    }

    return null;
  }

  Future<List<AttendanceCheckModel>> readTodayPunchData(String todayDate) async {
    final db = await instance.database;

    final result = await db.query(
      punchTableName,
      columns: PunchFields.values,
      where: '${PunchFields.punchDate} = ?',
      whereArgs: [todayDate],
    );

    return result.map((json) => AttendanceCheckModel.fromJson(json)).toList();
  }

  Future<List<AttendanceCheckModel>> readUncSyncPunchData() async {
    final db = await instance.database;

    final result = await db.query(
      punchTableName,
      columns: PunchFields.values,
      where: '${PunchFields.isSynced} = ?',
      whereArgs: [0],
    );

    return result.map((json) => AttendanceCheckModel.fromJson(json)).toList();
  }

  Future<int> getUnSyncedPunchCount() async {
    final db = await instance.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $punchTableName WHERE ${PunchFields.isSynced} = ?',
      [0],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<AttendanceCheckModel>> readLastPunchData() async {
    final db = await instance.database;

    final result = await db.query(
      punchTableName,
      columns: PunchFields.values,
      where: '${PunchFields.isSynced} = ?',
      whereArgs: [0],
    );

    return result.map((json) => AttendanceCheckModel.fromJson(json)).toList();
  }

  Future<int> update(AttendanceCheckModel punch) async {
    final db = await instance.database;

    return db.update(
      punchTableName,
      punch.toJson(),
      where: '${PunchFields.id} = ?',
      whereArgs: [punch.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      punchTableName,
      where: '${PunchFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTable() async {
    final db = await instance.database;
    return await db.delete(punchTableName);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}