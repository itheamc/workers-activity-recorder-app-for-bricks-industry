
import 'package:daily_records_sandip/models/record.dart';
import 'package:daily_records_sandip/models/worker.dart';
import 'package:daily_records_sandip/screens/select_workers_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';

import '../utils/route_handler.dart';

class NikashiScreen extends StatefulWidget {
  const NikashiScreen({Key? key}) : super(key: key);

  @override
  State<NikashiScreen> createState() => _NikashiScreenState();
}

class _NikashiScreenState extends State<NikashiScreen> {
  Worker? _worker;
  final records = <Record>[];
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _timesController;
  late TextEditingController _gotiController;

  @override
  void initState() {
    _timesController = TextEditingController();
    _gotiController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final total = records.isNotEmpty
        ? records
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
                    begin: const Offset(1.0, -0.1)));
            if (res != null) {
              setState(() {
                _worker = res;
              });
            }
          },
          scaleMinValue: 0.85,
          child: Text(_worker?.name ?? "Sandip Chaudhary"),
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
                                ),
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          records.add(Record(
                                              id: records.length,
                                              gota: num.parse(
                                                  _gotiController.text),
                                              line: num.parse(
                                                  _timesController.text)));
                                        });
                                        _timesController.text = "";
                                        _gotiController.text = "";
                                      }
                                    },
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
                            itemCount: records.length,
                            itemBuilder: (BuildContext context, int index) {
                              final record = records[index];
                              return ScaleTap(
                                onPressed: () {},
                                scaleMinValue: 0.85,
                                child: Card(
                                  elevation: 0.5,
                                  shadowColor: Colors.lightBlue.shade100,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text("${record.line}"),
                                              const Text("X"),
                                              Text("${record.gota}"),
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
                                          onTap: () {
                                            setState(() {
                                              records.remove(record);
                                            });
                                          },
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
            child: Padding(
              padding:
              const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.pink[800],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8.0),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "जम्मा",
                        style: _theme.textTheme.headline6
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    Text(
                      "$total",
                      style: _theme.textTheme.headline6
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "Save",
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
          ),
        ],
      ),
    );
  }
}
