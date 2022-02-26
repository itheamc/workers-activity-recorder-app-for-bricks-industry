
import '../utils/id_handler.dart';

class Record {
  String id;
  num first;
  num second;

  num? get total => first * second;

  Record({
    required this.id,
    required this.first,
    required this.second,
  });

  Record copy({String? id, num? first, num? second}) {
    return Record(
      id: id ?? this.id,
      first: first ?? this.first,
      second: second ?? this.second,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_value': first,
      'second_value': second,
    };
  }

  static Record fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'],
      first: map['first_value'] as num,
      second: map['second_value'] as num,
    );
  }

  static List<Record> records(List<Map<String, dynamic>> maps) {
    return maps.map((map) => fromMap(map)).toList();
  }

  // Function to create record
  static Record create(num first, num second) {
    return Record(id: IdHandler.uuid4(), first: first, second: second);
  }
}
