import 'package:uuid/uuid.dart';

class IdHandler {
  // UUID Version 4 generator function
  static String uuid4() {
    return const Uuid().v4();
  }
}