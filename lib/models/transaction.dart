import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/record_type.dart';
import 'package:daily_records_sandip/models/worker.dart';
import 'package:daily_records_sandip/utils/id_handler.dart';

class ATransaction {
  String id;
  Worker worker;
  List<Record> records;
  RecordType recordType;
  int created;
  int updated;

  ATransaction(
      {required this.id,
      required this.worker,
      required this.records,
      required this.recordType,
      required this.created,
      required this.updated});

  ATransaction copy(
      {String? id,
      Worker? worker,
      List<Record>? records,
      RecordType? recordType,
      int? created,
      int? updated}) {
    return ATransaction(
        id: id ?? this.id,
        worker: worker ?? this.worker,
        records: records ?? this.records,
        recordType: recordType ?? this.recordType,
        created: created ?? this.created,
        updated: updated ?? this.updated);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'worker': worker.id,
      'records': _recordsId,
      'record_type': recordType.name,
      'created': created,
      'updated': updated
    };
  }

  static ATransaction fromMap(Map<String, dynamic> map) {
    return ATransaction(
      id: map['id'],
      worker: map['worker'] as Worker,
      records: map['records'] as List<Record>,
      recordType: _record_type(map['record_type']),
      created: map['created'],
      updated: map['updated'],
    );
  }

  static List<ATransaction> transactions(List<Map<String, dynamic>> maps) {
    return maps.map((transaction) => fromMap(transaction)).toList();
  }

  String get _recordsId => records.map((e) => e.id).join(", ");

  // Function to get record type
  static RecordType _record_type(String s) {
    if (s.trim() == RecordType.pakki.name) {
      return RecordType.pakki;
    } else if (s.trim() == RecordType.bharai.name) {
      return RecordType.bharai;
    } else if (s.trim() == RecordType.nikashi.name) {
      return RecordType.nikashi;
    } else {
      return RecordType.unknown;
    }
  }

  // Function to create transaction
  static ATransaction create(
      {required Worker worker,
      required List<Record> records,
      required RecordType recordType}) {
    return ATransaction(
        id: IdHandler.uuid4(),
        worker: worker,
        records: records,
        recordType: recordType,
        created: DateTime.now().millisecondsSinceEpoch,
        updated: DateTime.now().millisecondsSinceEpoch);
  }
}
