import 'package:daily_records_sandip/models/worker.dart';
import 'package:daily_records_sandip/providers/database_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({Key? key}) : super(key: key);

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addWorker() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<DatabaseProvider>(context, listen: false).insertWorker(
            Worker.create(_nameController.text)
        );
        _nameController.text = "";
      } catch (e) {
        if (kDebugMode) print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    const _radius = 24.0;

    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        heightFactor: 0.25,
        widthFactor: 0.75,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_radius),
              topRight: Radius.circular(4.0),
              bottomLeft: Radius.circular(_radius),
              bottomRight: Radius.circular(_radius),
            ),
          ),
          color: Colors.pink.shade900,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              labelText: "कामदारको नाम",
                              labelStyle: _theme.textTheme.bodyText1?.copyWith(
                                  color: Colors.white, fontSize: 16.0),
                              border: InputBorder.none,
                              filled: true,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 7.5),
                              fillColor: Colors.white12),
                          validator: (str) {
                            if (str == null || str.trim().isEmpty) {
                              return "कृपया नाम लेख्नुहोस";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          style: _theme.textTheme.bodyText1
                              ?.copyWith(color: Colors.white, fontSize: 16.0),
                          // autofocus: true,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: ElevatedButton(
                          onPressed: _addWorker,
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              primary: Colors.white,
                              onPrimary: Colors.pink.shade900),
                          child: Text(
                            "ADD",
                            style: _theme.textTheme.button?.copyWith(
                              color: Colors.pink.shade900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4.0),
                      bottomLeft: Radius.circular(_radius)),
                  child: Ink(
                    width: 28.0,
                    height: 24.0,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                        color: _theme.dividerColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4.0),
                            bottomLeft: Radius.circular(_radius))),
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.close,
                        size: 16.0,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
