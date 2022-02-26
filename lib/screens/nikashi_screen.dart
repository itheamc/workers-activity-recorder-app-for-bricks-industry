import 'dart:async';

import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/worker.dart';
import 'package:daily_records_sandip/screens/select_workers_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:provider/provider.dart';

import '../models/record_type.dart';
import '../providers/database_provider.dart';
import '../utils/route_handler.dart';
import 'bharai_screen.dart';

class NikashiScreen extends StatefulWidget {
  const NikashiScreen({Key? key}) : super(key: key);

  @override
  State<NikashiScreen> createState() => _NikashiScreenState();
}

class _NikashiScreenState extends State<NikashiScreen> {
  Worker? _worker;
  final _records = <Record>[];
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _timesController;
  late TextEditingController _gotiController;
  bool error = false;
  String err = "";

  @override
  void initState() {
    _timesController = TextEditingController();
    _gotiController = TextEditingController();
    super.initState();
  }

  // Function to add record
  void _onRecordAdd() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _records.add(Record.create(num.parse(_timesController.text),
            num.parse(_gotiController.text)));
        _timesController.text = "";
        _gotiController.text = "";
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
    final total = _records.isNotEmpty
        ? _records
            .map((e) => e.total)
            .reduce((value, element) => (value ?? 0) + (element ?? 0))
        : 0;
    return Scaffold(
      backgroundColor: Colors.pink.shade400,
      appBar: AppBar(
        title: ScaleTap(
          onPressed: () async {
            var res = await Navigator.push(
                context,
                SlidePageRoute(const SelectWorkerSheet(),
                    begin: const Offset(-1.0, -0.15)));
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
      body: Consumer<DatabaseProvider>(
        builder: (_, provider, child) {
          return Column(
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
                                      controller: _timesController,
                                      decoration: InputDecoration(
                                          labelText: "खेप",
                                          labelStyle: _theme.textTheme.bodyText1
                                              ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                          border: InputBorder.none,
                                          fillColor: Colors.blueGrey),
                                      validator: (str) {
                                        if (str == null || str.trim().isEmpty) {
                                          return "कृपया खेप लेख्नुहोस";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      style: _theme.textTheme.bodyText1
                                          ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 16.0),
                                      autofocus: true,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    TextFormField(
                                      controller: _gotiController,
                                      decoration: InputDecoration(
                                        labelText: "कौरी/गोटी",
                                        labelStyle: _theme.textTheme.bodyText1
                                            ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                        border: InputBorder.none,
                                        fillColor: Colors.red,
                                      ),
                                      validator: (str) {
                                        if (str == null || str.trim().isEmpty) {
                                          return "कृपया कौरी/गोटी लेख्नुहोस";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      style: _theme.textTheme.bodyText1
                                        ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16.0),
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
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          side: const BorderSide(
                                              color: Colors.white
                                          ),
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
                recordType: RecordType.nikashi,
                onError: (err) => _showError(err),
                onSuccess: () {
                  setState(() {
                    _records.clear();
                  });
                },
              ),
            ],
          );
        }
      ),
    );
  }
}
