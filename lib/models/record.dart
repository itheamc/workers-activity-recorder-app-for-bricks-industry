
class Record {
  int? id;
  num? line;
  num? gota;

  num? get total => line! * gota!;

  Record({this.id, this.line, this.gota});
}