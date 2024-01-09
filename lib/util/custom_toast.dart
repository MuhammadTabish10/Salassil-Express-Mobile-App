import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:salsel_express/util/themes.dart';

class CustomToast {
  static Flushbar? _currentFlushbar;

  static void showAlert(BuildContext context, String message) {
    _currentFlushbar?.dismiss(); // Dismiss the current Flushbar, if any

    _currentFlushbar = Flushbar(
      title: 'Alert',
      message: message,
      duration: const Duration(seconds: 3),
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: primarySwatch,
      boxShadows: [
        BoxShadow(
          color: Colors.grey[600] ?? Colors.grey,
          offset: const Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      mainButton: TextButton(
        onPressed: () {
          _currentFlushbar?.dismiss();
        },
        child: const Text(
          'OK',
          style: TextStyle(color: Colors.white),
        ),
      ),
    )..show(context);
  }
}
