import 'package:flutter/material.dart';
import 'package:gptuner/features/login/login_screen.dart';
import 'package:gptuner/features/signup/signup_screen.dart';
import 'package:gptuner/shared/utils/constants.dart';
import 'package:gptuner/theme/app_theme.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPTuner',
      navigatorKey: navigatorKey,
      theme: AppTheme.getTheme(),
      routes: routes,
      home: const LoginScreen(),
    );
  }
}

//routes for different screen
var routes = <String, WidgetBuilder>{
  Routes.loginScreen: (BuildContext context) => LoginScreen(),
  Routes.signupScreen: (BuildContext context) => SignUpScreen(),
};
