import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/transaction.dart';
import 'package:intl/intl.dart';

extension StrExtension on String {
  List<String> asList(String separator) {
    return split(separator);
  }
}


extension IntExtension on int {
  String toDate() {
    var date = DateTime.fromMillisecondsSinceEpoch(this);
    var dFormat = DateFormat("yyyy-MM-dd");
    String formattedDate = dFormat.format(date);
    return formattedDate;
  }
}

extension ATransactionExtension on List<ATransaction> {
  List<ATransactions> toATransactions() {
    List<ATransactions> temps = [];
    Set<String> dates = map((e) => e.created.toDate()).toSet();

    for (final date in dates) {
      List<ATransaction> trans = [];
      for (final t in this) {
        if (date == t.created.toDate()) {
          trans.add(t);
        }
      }
      temps.add(ATransactions(label: date, transactions: trans));
    }
    return temps;
  }
}


extension RecordsExtension on List<Record> {
  int? total() {
    return isNotEmpty ? map((e) => e.total).reduce((value, element) => (value ?? 0) + (element ?? 0))?.round() : 0;
  }
}