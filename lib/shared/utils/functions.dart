import 'package:flutter/material.dart';
import 'package:gptuner/main.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/providers/document_state.dart';
import 'package:gptuner/shared/utils/constants.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

bool emailValidatorBool(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return false;
  }

  return true;
}

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
        messenger.currentState!.removeCurrentSnackBar();
      },
    ),
  );
  messenger.currentState!
    ..clearSnackBars()
    ..showSnackBar(snackBar);
}

void _showLogoutConfirmation(
    BuildContext parentContext, AuthState state, DocumentState documentState) {
  showDialog(
    context: parentContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
            child: Text('Log Out',
                style: AppTheme.getTheme().textTheme.displaySmall)),
        content: Text('Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: AppTheme.getTheme().textTheme.titleMedium),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Yes',
                        style: AppTheme.getTheme().textTheme.bodyMedium),
                  ),
                  onPressed: () {
                    documentState.reset();
                    state.logout().then((_) {
                      if (Navigator.canPop(context)) {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.loginScreen,
                            (Route<dynamic> route) => false);
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No',
                        style: AppTheme.getTheme().textTheme.bodyMedium),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
            ],
          ),
        ],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      );
    },
  );
}

Widget buildSidebar(
    AuthState state, BuildContext context, DocumentState documentState) {
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
                style: AppTheme.getTheme().textTheme.headlineSmall,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.white),
            title: Text('Profile',
                style: AppTheme.getTheme().textTheme.labelLarge),
            onTap: () {
              Navigator.pushNamed(context, Routes.profileScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard, color: Colors.white),
            title: Text('Leaderboard',
                style: AppTheme.getTheme().textTheme.labelLarge),
            onTap: () {
              Navigator.pushNamed(context, Routes.leaderboardScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: Text('Settings',
                style: AppTheme.getTheme().textTheme.labelLarge),
            onTap: () {
              Navigator.pushNamed(context, Routes.settingsScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: Text('Log Out',
                style: AppTheme.getTheme().textTheme.labelLarge),
            onTap: () {
              _showLogoutConfirmation(context, state, documentState);
            },
          ),
        ],
      ),
    ),
  );
}

Future<http.Response> sendRequest(String endpoint,
    {String method = 'GET',
    Map<String, String>? headersAlt,
    dynamic body,
    String? hostUrl}) async {
  const Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept-Encoding": "gzip,deflate,br",
  };
  final uri = Uri.parse('$hostUrl$endpoint');
  headersAlt = {...headers, ...?headersAlt};

  if (method == 'POST') {
    return await http.post(uri, headers: headersAlt, body: jsonEncode(body));
  } else if (method == 'PATCH') {
    return await http.patch(uri, headers: headersAlt, body: jsonEncode(body));
  } else {
    return await http.get(uri, headers: headersAlt);
  }
}

PageRouteBuilder customPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade transition configuration
      const beginFade = 0.0;
      const endFade = 1.0;
      var tweenFade = Tween(begin: beginFade, end: endFade);
      var fadeAnimation = animation.drive(tweenFade);

      // Scale transition configuration
      const beginScale = 0.9;
      const endScale = 1.0;
      var tweenScale = Tween(begin: beginScale, end: endScale)
          .chain(CurveTween(curve: Curves.easeInOut));
      var scaleAnimation = animation.drive(tweenScale);

      return FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: child,
        ),
      );
    },
  );
}

void showSnackbarOnServerExceptions(int statusCode) {
  if (statusCode == 401) {
    showSnackbar("Authentication error. Please log out and log in again.",
        backgroundColor: AppTheme.getTheme().colorScheme.error);
  } else {
    showSnackbar("There has been a server error. Please try again later.",
        backgroundColor: AppTheme.getTheme().colorScheme.error);
  }
}

Widget buildNoAvailableDataMessage(String message, BuildContext context) {
  return Center(
    child: Card(
      color: Colors.grey.shade400,
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: AppTheme.getTheme().textTheme.titleMedium,
          ),
        ),
      ),
    ),
  );
}
