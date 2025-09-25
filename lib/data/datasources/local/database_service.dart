import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/appointment_model.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'appointments.db';
  static const int _databaseVersion = 1;
  static const String _appointmentsTable = 'appointments';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_appointmentsTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        date_time INTEGER NOT NULL,
        duration INTEGER NOT NULL,
        description TEXT,
        location TEXT,
        status TEXT NOT NULL DEFAULT 'scheduled',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX idx_appointments_date_time ON $_appointmentsTable(date_time)
    ''');

    await db.execute('''
      CREATE INDEX idx_appointments_status ON $_appointmentsTable(status)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic for future versions
    }
  }

  Future<List<AppointmentModel>> getAllAppointments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _appointmentsTable,
      orderBy: 'date_time ASC',
    );

    return List.generate(maps.length, (i) {
      return AppointmentModel.fromMap(maps[i]);
    });
  }

  Future<List<AppointmentModel>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _appointmentsTable,
      where: 'date_time >= ? AND date_time <= ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'date_time ASC',
    );

    return List.generate(maps.length, (i) {
      return AppointmentModel.fromMap(maps[i]);
    });
  }

  Future<AppointmentModel?> getAppointmentById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _appointmentsTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return AppointmentModel.fromMap(maps.first);
    }
    return null;
  }

  Future<String> insertAppointment(AppointmentModel appointment) async {
    final db = await database;
    await db.insert(
      _appointmentsTable,
      appointment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return appointment.id;
  }

  Future<void> updateAppointment(AppointmentModel appointment) async {
    final db = await database;
    await db.update(
      _appointmentsTable,
      appointment.toMap(),
      where: 'id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<void> deleteAppointment(String id) async {
    final db = await database;
    await db.delete(
      _appointmentsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<AppointmentModel>> searchAppointments(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _appointmentsTable,
      where: 'title LIKE ? OR description LIKE ? OR location LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'date_time ASC',
    );

    return List.generate(maps.length, (i) {
      return AppointmentModel.fromMap(maps[i]);
    });
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}