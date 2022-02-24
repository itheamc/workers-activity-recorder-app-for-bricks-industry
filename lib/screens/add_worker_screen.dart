import 'package:flutter/material.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({Key? key}) : super(key: key);

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        heightFactor: 0.65,
        widthFactor: 0.9,
        child: Card(
          margin: const EdgeInsets.only(right: 10.0, top: 30.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(2.0),
              bottomLeft: Radius.circular(24.0),
              bottomRight: Radius.circular(24.0),
            ),
          ),
          child: SizedBox(
            height: _size.height * 0.5,
          ),
        ),
      ),
    );
  }
}
