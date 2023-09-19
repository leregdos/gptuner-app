import 'package:flutter/material.dart';
import 'package:gptuner/features/home/home_screen.dart';
import 'package:gptuner/features/login/login_screen.dart';
import 'package:gptuner/features/signup/signup_screen.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/shared/utils/constants.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> messenger =
    GlobalKey<ScaffoldMessengerState>();
void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AuthState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPTuner',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messenger,
      theme: AppTheme.getTheme(),
      routes: routes,
      home: const LoginScreen(),
    );
  }
}

//routes for different screen
var routes = <String, WidgetBuilder>{
  Routes.loginScreen: (BuildContext context) => const LoginScreen(),
  Routes.signupScreen: (BuildContext context) => const SignupScreen(),
  Routes.homeScreen: (BuildContext context) => const HomeScreen(),
};
