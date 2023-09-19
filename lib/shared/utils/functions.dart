import 'package:flutter/material.dart';
import 'package:gptuner/main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter your email";
  }
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return "Please enter a valid email address";
  }

  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter your password";
  }
  if (value.length < 8) {
    return "Valid passwords must be at least 8 characters";
  }

  return null;
}

DateTime parseJWTExpiry(String expiryDate) {
  DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
  DateTime parsedDate = format.parse(expiryDate);
  return parsedDate;
}

void showSnackbar(
  String message, {
  Color backgroundColor = const Color(0xFF73E7E0),
  String labelMessage = "OK",
  Color textColor = Colors.white,
}) {
  SnackBar snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    content: Text(message),
    backgroundColor: backgroundColor,
    duration: const Duration(seconds: 10),
    action: SnackBarAction(
      label: labelMessage,
      textColor: textColor,
      onPressed: () {
        messenger.currentState!..removeCurrentSnackBar();
      },
    ),
  );
  messenger.currentState!
    ..clearSnackBars()
    ..showSnackBar(snackBar);
}
