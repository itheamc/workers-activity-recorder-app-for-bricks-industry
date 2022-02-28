import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ADialog {
  static Future<bool?> showDialog(BuildContext context,
      {required String? title,
      String? desc,
      IconData? icon,
      String? positiveBtnText,
      String? negativeBtnText}) {
    final _theme = Theme.of(context);

    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => FractionallySizedBox(
        widthFactor: 0.75,
        heightFactor: 0.3,
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(24.0),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Colors.yellow.shade500,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon ?? Icons.delete_forever_outlined,
                        size: 28.0,
                        color: Colors.pink.shade900,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        title ?? "हटाउनुहोस !!",
                        style: _theme.textTheme.headline5?.copyWith(
                          color: Colors.pink.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    desc ?? "के तपाई यो कामदारलाई हटाऊन चाहनुहुन्छ?",
                    style: _theme.textTheme.bodyText1?.copyWith(
                      color: Colors.pink.shade900,
                    ),
                    textScaleFactor: 1.3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, false),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48.0),
                              ),
                            ),
                            child: Text(negativeBtnText ?? "नाई")),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              onPrimary: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(48.0),
                              ),
                            ),
                            child: Text(positiveBtnText ?? "चाहन्छु")),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
