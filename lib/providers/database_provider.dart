import 'package:daily_records_sandip/database/a_database.dart';
import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/transaction.dart';
import 'package:daily_records_sandip/models/worker.dart';
import 'package:daily_records_sandip/utils/progress_status.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider with ChangeNotifier {
  ADatabase? _aDatabase;
  Worker? _tempWorker;
  Record? _tempRecord;
  ATransaction? _tempTransaction;
  List<ATransaction> transactionsList = [];
  List<Worker> workersList = [];
  ADatabaseStatus _transactionStatus = ADatabaseStatus.none;
  ADatabaseStatus _workerStatus = ADatabaseStatus.none;

  ADatabaseStatus get transactionStatus => _transactionStatus;

  ADatabaseStatus get workerStatus => _workerStatus;

  ATransaction? _selectedATransaction;
  ATransaction? get selectedTransaction => _selectedATransaction;

  void handleSelect(ATransaction? t) {
    _selectedATransaction = t;
    notifyListeners();
  }


  /// FUnction to initialize database
  Future<ADatabase> init() async {
    return await ADatabase.initialize();
  }

  ///-------------------------------------------------------
  ///------------------WORKERS------------------------------

  Future<List<Worker>> workers() async {
    _aDatabase ??= await init();
    workersList = await _aDatabase?.workers() ?? List.empty();
    notifyListeners();
    return workersList;
  }

  Future<void> insertWorker(Worker worker) async {
    _workerStatus = ADatabaseStatus.inserting;
    notifyListeners();
    _aDatabase ??= await init();
    await _aDatabase?.insertWorker(worker);
    _workerStatus = ADatabaseStatus.inserted;
    notifyListeners();
    await workers();
  }

  Future<void> updateWorker(Worker worker) async {
    _aDatabase ??= await init();
    await _aDatabase?.updateWorker(worker);
    notifyListeners();
  }

  Future<void> deleteWorker(Worker worker) async {
    _aDatabase ??= await init();
    _tempWorker = worker.copy();
    final res = await _aDatabase?.deleteWorker(worker);
    if (res != null && res) workersList.remove(worker);
    notifyListeners();
  }

  Future<void> handleWorkerUndo() async {
    if (_tempWorker != null) {
      await insertWorker(_tempWorker!);
      await workers();
    }
  }

  ///-------------------------------------------------------
  ///------------------Records------------------------------

  Future<List<Record>> records() async {
    _aDatabase ??= await init();
    return await _aDatabase?.records() ?? List.empty();
  }

  Future<void> insertRecord(Record record) async {
    _aDatabase ??= await init();
    await _aDatabase?.insertRecord(record);
  }

  Future<void> updateRecord(Record record) async {
    _aDatabase ??= await init();
    await _aDatabase?.updateRecord(record);
  }

  Future<void> deleteRecord(Record record) async {
    _aDatabase ??= await init();
    _tempRecord = record.copy();
    await _aDatabase?.deleteRecord(record);
  }

  Future<void> handleRecordUndo() async {
    if (_tempRecord != null) {
      await insertRecord(_tempRecord!);
    }
  }

  ///-------------------------------------------------------
  ///------------------ATransaction------------------------------

  Future<List<ATransaction>> transactions() async {
    _aDatabase ??= await init();
    transactionsList = await _aDatabase?.transactions() ?? List.empty();
    notifyListeners();
    return transactionsList;
  }

  Future<void> insertTransaction(ATransaction transaction) async {
    _transactionStatus = ADatabaseStatus.inserting;
    notifyListeners();
    _aDatabase ??= await init();
    for (final r in transaction.records) {
      await insertRecord(r);
    }
    await _aDatabase?.insertTransaction(transaction);
    _transactionStatus = ADatabaseStatus.inserted;
    notifyListeners();
    transactions();
  }

  Future<void> updateTransaction(ATransaction transaction) async {
    _aDatabase ??= await init();
    await _aDatabase?.updateTransaction(transaction);
    notifyListeners();
    transactions();
  }

  Future<void> deleteTransaction(ATransaction transaction) async {
    _aDatabase ??= await init();
    _tempTransaction = transaction.copy();
    await _aDatabase?.deleteTransaction(transaction);
    notifyListeners();
    transactions();
  }

  Future<void> handleTransactionUndo() async {
    if (_tempTransaction != null) {
      await insertTransaction(_tempTransaction!);
    }
  }
}
