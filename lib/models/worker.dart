import 'package:daily_records_sandip/utils/date_handler.dart';
import 'package:daily_records_sandip/utils/id_handler.dart';

class Worker {
  String id;
  String name;
  int created;

  Worker({required this.id, required this.name, required this.created});

  // Function to create map
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'created': created};
  }

  // Function to copy and/or edit worker object
  Worker copy({String? id, String? name, int? created}) {
    return Worker(id: id ?? this.id, name: name ?? this.name, created: created ?? this.created);
  }

  // Function to convert map to Worker object
  static Worker fromMap(Map<String, dynamic> map) {
    return Worker(id: map['id'], name: map['name'], created: map['created']);
  }

  // Function to create workers list from maps
  static List<Worker> workers(List<Map<String, dynamic>> maps) {
    return maps.map((map) => fromMap(map)).toList();
  }

  // Function to create worker
  static Worker create(String name) {
    return Worker(id: IdHandler.uuid4(), name: name, created: DateHandler.current);
  }
}
