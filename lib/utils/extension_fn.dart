import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

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

  String toNepaliDate() {
    var date = DateTime.fromMillisecondsSinceEpoch(this).toNepaliDateTime();
    var dFormat = NepaliDateFormat("yyyy-MM-dd");
    String formattedDate = dFormat.format(date);
    return formattedDate;
  }

  String toNpStyleDate() {
    var date = DateTime.fromMillisecondsSinceEpoch(this).toNepaliDateTime();
    var dFormat = NepaliDateFormat("MMMM dd, yyyy");
    String formattedDate = dFormat.format(date);
    return formattedDate;
  }
}

extension ATransactionExtension on List<ATransaction> {
  List<ATransactions> toATransactions() {
    List<ATransactions> temps = [];
    Set<String> dates = map((e) => e.created.toNepaliDate()).toSet();

    for (final date in dates) {
      List<ATransaction> trans = [];
      for (final t in this) {
        if (date == t.created.toNepaliDate()) {
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