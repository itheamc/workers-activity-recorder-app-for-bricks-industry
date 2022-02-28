import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/transaction.dart';
import 'package:daily_records_sandip/models/worker.dart';
import 'package:daily_records_sandip/utils/extension_fn.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ADatabase {
  static const String _dbName = "amc_database.db";
  static const String _workersTable = "workers";
  static const String _recordsTable = "records";
  static const String _transactionsTable = "transactions";
  static const int _version = 1;

  Database? _database;

  // Private Constructor
  ADatabase._();

  static Future<ADatabase> initialize() async {
    ADatabase todoDatabase = ADatabase._()
      .._database = await _createDatabase();
    return todoDatabase;
  }

  // Private static function to create and return the instance of sql database
  static Future<Database> _createDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), _dbName),
        version: _version, onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE $_workersTable (id TEXT PRIMARY KEY, name TEXT, created INTEGER)');
          await db.execute(
              'CREATE TABLE $_recordsTable (id TEXT PRIMARY KEY, first_value REAL, second_value REAL)');
          await db.execute(
              'CREATE TABLE $_transactionsTable (id TEXT PRIMARY KEY, worker TEXT, records TEXT, record_type TEXT, created INTEGER, updated INTEGER)');
        });
  }

  ///--------------------------------------------------------------------------
  ///----------------------------FOR WORKERS-----------------------------------
  ///--------------------------------------------------------------------------
  // Function to fetch workers
  Future<List<Worker>> workers() async {
    List<Map<String, dynamic>>? maps = await _database?.query(_workersTable, orderBy: 'created DESC');
    return maps != null && maps.isNotEmpty ? Worker.workers(maps) : List.empty();
  }

  Future<Worker?> worker(String id) async {
    var maps = await _database?.query(_workersTable, where: 'id = ?', whereArgs: [id]);
    return maps != null && maps.isNotEmpty ? Worker.fromMap(maps.first) : null;
  }

  // Function to insert worker
  Future<bool> insertWorker(Worker worker) async {
    int? res = await _database?.insert(
      _workersTable,
      worker.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return res != null;
  }

  // Function to delete given worker
  Future<bool> deleteWorker(Worker worker) async {
    int? res = await _database
        ?.delete(_workersTable, where: 'id = ?', whereArgs: [worker.id]);
    return res != null;
  }

  // Function to update worker
  Future<bool> updateWorker(Worker worker) async {
    int? res = await _database?.update(_workersTable, worker.toMap(),
        where: 'id = ?',
        whereArgs: [worker.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res != null;
  }


  ///--------------------------------------------------------------------------
  ///----------------------------FOR RECORDS-----------------------------------
  ///--------------------------------------------------------------------------
  // Function to fetch workers
  Future<List<Record>> records() async {
    List<Map<String, dynamic>>? maps = await _database?.query(_recordsTable);
    return maps != null && maps.isNotEmpty ? Record.records(maps) : List.empty();
  }

  Future<Record?> record(String id) async {
    var maps = await _database?.query(_recordsTable, where: 'id = ?', whereArgs: [id]);
    return maps != null && maps.isNotEmpty ? Record.fromMap(maps.first) : null;
  }


  // Function to insert worker
  Future<bool> insertRecord(Record record) async {
    int? res = await _database?.insert(
      _recordsTable,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return res != null;
  }

  // Function to delete given worker
  Future<bool> deleteRecord(Record record) async {
    int? res = await _database
        ?.delete(_recordsTable, where: 'id = ?', whereArgs: [record.id]);
    return res != null;
  }

  // Function to update worker
  Future<bool> updateRecord(Record record) async {
    int? res = await _database?.update(_recordsTable, record.toMap(),
        where: 'id = ?',
        whereArgs: [record.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res != null;
  }

  ///--------------------------------------------------------------------------
  ///--------------------------FOR TRANSACTIONS--------------------------------
  ///--------------------------------------------------------------------------
  // Function to fetch transaction
  Future<List<ATransaction>> transactions() async {
    List<Map<String, dynamic>>? maps = await _database?.query(_transactionsTable, orderBy: 'created DESC', limit: 200);
    if (maps != null && maps.isNotEmpty) {
      List<Map<String, dynamic>> temps = [];
      for (var map in maps) {
        Map<String, dynamic> tMap = Map.fromEntries(map.entries);
        final w = await worker(tMap['worker']);
        if (w == null) continue;
        await tMap.update('worker', (value) => w);
        List<Record> records = [];
        for (var id in (tMap['records'] as String).asList(', ')) {
          var r = await record(id);
          if (r == null) continue;
          records.add(r);
        }
        if (records.isEmpty) continue;
        await tMap.update('records', (value) => records);
        temps.add(tMap);
      }
      return ATransaction.transactions(temps);
    }
    return List.empty();
  }


  Future<ATransaction?> transaction(String id) async {
    var maps = await _database?.query(_transactionsTable, where: 'id = ?', whereArgs: [id]);
    return maps != null && maps.isNotEmpty ? ATransaction.fromMap(maps.first) : null;
  }


  // Function to insert transaction
  Future<bool> insertTransaction(ATransaction transaction) async {
    int? res = await _database?.insert(
      _transactionsTable,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return res != null;
  }

  // Function to delete given transaction
  Future<bool> deleteTransaction(ATransaction transaction) async {
    int? res = await _database
        ?.delete(_transactionsTable, where: 'id = ?', whereArgs: [transaction.id]);
    return res != null;
  }

  // Function to update transaction
  Future<bool> updateTransaction(ATransaction transaction) async {
    int? res = await _database?.update(_transactionsTable, transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res != null;
  }

  ///---------------------------------------------------------------------------
  // Function to close the database
  Future<void> close() async {
    if (_database != null && _database?.isOpen == true) {
      await _database?.close();
    }
  }
}