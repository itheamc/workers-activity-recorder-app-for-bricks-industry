import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/transaction.dart';
import 'package:daily_records_sandip/providers/database_provider.dart';
import 'package:daily_records_sandip/utils/date_handler.dart';
import 'package:daily_records_sandip/utils/extension_fn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/a_dialog.dart';
import 'bharai_screen.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({Key? key}) : super(key: key);

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  /// Function to add record
  // void _onRecordAdd() {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _records.add(Record.create(num.parse(_heightController.text),
  //           num.parse(_lengthController.text)));
  //       _heightController.text = "";
  //       _lengthController.text = "";
  //     });
  //   }
  // }

  /// Function to handle remove
  Future<void> _remove(ATransaction transaction, Record record) async {
    final res = await ADialog.showDialog(context,
        title: "हटाउनुहोस !!",
        desc: "Are you sure want to delete this record?");
    if (res != null && res) {
      final provider = Provider.of<DatabaseProvider>(context, listen: false);
      final tmp_rec = List<Record>.from(transaction.records);
      final tmp_res = tmp_rec.remove(record);
      if (tmp_res) {
        if (tmp_rec.isNotEmpty) {
          final updatedTransaction =
              transaction.copy(records: tmp_rec, updated: DateHandler.current);
          await provider.updateTransaction(updatedTransaction);
          await provider.deleteRecord(record);
          provider.handleSelect(updatedTransaction);
        } else {
          await provider.deleteTransaction(transaction);
          await provider.deleteRecord(record);
          provider.handleSelect(null);
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Consumer<DatabaseProvider>(
      builder: (_, provider, child) {
        final transaction = provider.selectedTransaction;
        final _records = transaction?.records;
        final _worker = transaction?.worker;
        final _total = _records?.total() ?? 0;

        return Scaffold(
          backgroundColor: Colors.orange.shade200,
          appBar: AppBar(
            title: Text(
              "${_worker?.name}  (${transaction?.created.toNpStyleDate()})",
              style: _theme.textTheme.bodyText1
                  ?.copyWith(color: Colors.pink.shade900),
              textAlign: TextAlign.center,
              textScaleFactor: 1.4,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: Card(
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.0),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade200,
                            Colors.orange.shade300,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: _records != null
                              ? ListView.builder(
                                  itemCount: _records.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final record = _records[index];
                                    return RecordTile(
                                      record: record,
                                      onRemoved: () =>
                                          _remove(transaction!, record),
                                    );
                                  },
                                )
                              : null),
                    ),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1.0,
                child: TotalSection(
                  total: _total,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
