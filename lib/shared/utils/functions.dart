import 'package:flutter/material.dart';
import 'package:gptuner/main.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/shared/utils/constants.dart';
import 'package:gptuner/theme/app_theme.dart';
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

Widget buildSidebar(AuthState state, BuildContext context) {
  return Drawer(
    child: Container(
      color: const Color(0xFF8AA1A9), // Black-greyish color
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF8AA1A9),
            ),
            child: Center(
              child: Text(
                'Menu',
                style: AppTheme.getTheme().textTheme.headline5,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.white),
            title: Text('Profile', style: AppTheme.getTheme().textTheme.button),
            onTap: () {
              Navigator.pushNamed(context, Routes.profileScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title:
                Text('Settings', style: AppTheme.getTheme().textTheme.button),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: Text('Log Out', style: AppTheme.getTheme().textTheme.button),
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
