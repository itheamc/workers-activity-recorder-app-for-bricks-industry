import 'dart:async';

import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/record_type.dart';
import 'package:daily_records_sandip/models/transaction.dart';
import 'package:daily_records_sandip/models/worker.dart';
import 'package:daily_records_sandip/providers/database_provider.dart';
import 'package:daily_records_sandip/screens/select_workers_sheet.dart';
import 'package:daily_records_sandip/utils/extension_fn.dart';
import 'package:daily_records_sandip/utils/progress_status.dart';
import 'package:daily_records_sandip/utils/route_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:provider/provider.dart';

class BharaiScreen extends StatefulWidget {
  const BharaiScreen({Key? key}) : super(key: key);

  @override
  State<BharaiScreen> createState() => _BharaiScreenState();
}

class _BharaiScreenState extends State<BharaiScreen> {
  Worker? _worker;
  final _records = <Record>[];
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _heightController;
  late TextEditingController _lengthController;
  bool error = false;
  String err = "";

  @override
  void initState() {
    _heightController = TextEditingController();
    _lengthController = TextEditingController();
    super.initState();
  }

  // Function to add record
  void _onRecordAdd() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _records.add(Record.create(num.parse(_heightController.text),
            num.parse(_lengthController.text)));
        _heightController.text = "";
        _lengthController.text = "";
      });
    }
  }

  // Show error
  void _showError(String err) async {
    setState(() {
      this.err = err;
      error = true;
    });
    Timer(const Duration(milliseconds: 2500), () {
      setState(() {
        error = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final total = _records.total() ?? 0;
    return Scaffold(
      backgroundColor: Colors.pink.shade400,
      appBar: AppBar(
        title: ScaleTap(
          onPressed: () async {
            var res = await Navigator.push(
                context,
                SlidePageRoute(const SelectWorkerSheet(),
                    begin: const Offset(1.0, -0.5)));
            if (res != null) {
              setState(() {
                _worker = res;
              });
            }
          },
          scaleMinValue: 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_worker?.name ?? "कामदारहरु छान्नुहोस्।"),
              if (error)
                Text(
                  err,
                  style: _theme.textTheme.caption?.copyWith(
                      color: Colors.yellowAccent, fontStyle: FontStyle.italic),
                ),
            ],
          ),
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
                      colors: [Colors.pink.shade200, Colors.pink.shade400],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _heightController,
                                  decoration: InputDecoration(
                                      labelText: "उचाई",
                                      labelStyle: _theme.textTheme.bodyText1
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                      border: InputBorder.none,
                                      fillColor: Colors.blueGrey),
                                  validator: (str) {
                                    if (str == null || str.trim().isEmpty) {
                                      return "कृपया उचाई लेख्नुहोस";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  style: _theme.textTheme.bodyText1?.copyWith(
                                      color: Colors.white, fontSize: 16.0),
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                TextFormField(
                                  controller: _lengthController,
                                  decoration: InputDecoration(
                                    labelText: "लम्बाई",
                                    labelStyle: _theme.textTheme.bodyText1
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                    border: InputBorder.none,
                                    fillColor: Colors.red,
                                  ),
                                  validator: (str) {
                                    if (str == null || str.trim().isEmpty) {
                                      return "कृपया लम्बाई लेख्नुहोस";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  style: _theme.textTheme.bodyText1?.copyWith(
                                      color: Colors.white, fontSize: 16.0),
                                  textInputAction: TextInputAction.previous,
                                ),
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: OutlinedButton(
                                    onPressed: _onRecordAdd,
                                    child: Text(
                                      "Add",
                                      style: _theme.textTheme.button
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      side:
                                          const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: ListView.builder(
                            itemCount: _records.length,
                            itemBuilder: (BuildContext context, int index) {
                              final record = _records[index];
                              return RecordTile(
                                record: record,
                                onRemoved: () {
                                  setState(() {
                                    _records.remove(record);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1.0,
            child: TotalSection(total: total),
          ),
          SaveButton(
            worker: _worker,
            records: _records,
            recordType: RecordType.bharai,
            onError: (err) => _showError(err),
            onSuccess: () {
              setState(() {
                _records.clear();
              });
            },
          ),
        ],
      ),
    );
  }
}

/// Record tile
class RecordTile extends StatelessWidget {
  final Record record;
  final VoidCallback? onRemoved;

  const RecordTile({Key? key, required this.record, this.onRemoved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return ScaleTap(
      onPressed: () {},
      scaleMinValue: 0.85,
      child: Card(
        elevation: 0.5,
        shadowColor: Colors.lightBlue.shade100,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("${record.first}"),
                    const Text("X"),
                    Text("${record.second}"),
                    const Text("="),
                    Text(
                      "${record.total}",
                      style: _theme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: onRemoved,
                child: const Icon(
                  Icons.close,
                  size: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for total section
class TotalSection extends StatelessWidget {
  final num? total;
  final Color? color;
  const TotalSection({Key? key, required this.total, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: color ?? Colors.pink.shade800,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(8.0),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "जम्मा",
                style:
                    _theme.textTheme.headline6?.copyWith(color: Colors.white),
              ),
            ),
            Text(
              "$total",
              style: _theme.textTheme.headline6?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// Button Widget
class SaveButton extends StatelessWidget {
  final Worker? worker;
  final List<Record> records;
  final RecordType recordType;
  final Function(String err)? onError;
  final VoidCallback? onSuccess;

  const SaveButton({
    Key? key,
    required this.worker,
    required this.records,
    required this.recordType,
    this.onError,
    this.onSuccess,
  }) : super(key: key);

  // Function to add transaction
  Future<void> _onTransactionAdd(DatabaseProvider provider) async {
    if (worker == null) {
      if (onError != null) onError!("कृपया कामदार छान्नुहोस्।");
      return;
    }
    if (records.isEmpty) {
      if (onError != null) onError!("कृपया पहिले डेटा एड गर्नुहोस्।");
      return;
    }
    if (provider.transactionStatus == ADatabaseStatus.inserting) {
      if (onError != null) onError!("डेटा एड भइरहेको छ। कृपया परखिनुहोस।");
      return;
    }
    await provider.insertTransaction(ATransaction.create(
        worker: worker!, records: records, recordType: RecordType.bharai));
    if (onSuccess != null) onSuccess!();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      child: Consumer<DatabaseProvider>(builder: (_, provider, index) {
        return Stack(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: ElevatedButton(
                onPressed: () async {
                  await _onTransactionAdd(provider);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "SAVE",
                    style: _theme.textTheme.bodyText1
                        ?.copyWith(color: Colors.pink[900], fontSize: 16.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 20.0,
                    onPrimary: Colors.lightBlueAccent),
              ),
            ),
            if (provider.transactionStatus == ADatabaseStatus.inserting)
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50.0,
                  width: 90.0,
                  alignment: Alignment.centerLeft,
                  child: const SizedBox(
                    width: 15.0,
                    height: 15.0,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 1.75,
                    ),
                  ),
                ),
              )
          ],
        );
      }),
    );
  }
}
