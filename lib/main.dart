import 'package:flutter/material.dart';
import 'package:gptuner/features/home/home_screen.dart';
import 'package:gptuner/features/login/login_screen.dart';
import 'package:gptuner/features/profile/profile_screen.dart';
import 'package:gptuner/features/settings/settings_screen.dart';
import 'package:gptuner/features/signup/signup_screen.dart';
import 'package:gptuner/features/submit_demonstration/submit_demonstration.dart';
import 'package:gptuner/features/submit_prompt/submit_prompt.dart';
import 'package:gptuner/features/update_password/update_password.dart';
import 'package:gptuner/features/validate/validate_submissions.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/providers/document_state.dart';
import 'package:gptuner/shared/utils/constants.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
GlobalKey<ScaffoldMessengerState> messenger =
    GlobalKey<ScaffoldMessengerState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthState()),
        ChangeNotifierProvider(create: (context) => DocumentState())
      ],
      child: MaterialApp(
        title: 'GPTuner',
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: messenger,
        theme: AppTheme.getTheme(),
        routes: routes,
        home: const LoginScreen(),
      ),
    );
  }
}

//routes for different screen
var routes = <String, WidgetBuilder>{
  Routes.loginScreen: (BuildContext context) => const LoginScreen(),
  Routes.signupScreen: (BuildContext context) => const SignupScreen(),
  Routes.homeScreen: (BuildContext context) => const HomeScreen(),
  Routes.profileScreen: (BuildContext context) => const ProfileScreen(),
  Routes.settingsScreen: (BuildContext context) => const SettingsScreen(),
  Routes.updatePasswordScreen: (BuildContext context) =>
      const UpdatePasswordScreen(),
  Routes.submitPromptScreen: (BuildContext context) =>
      const SubmitPromptScreen(),
  Routes.submitDemonstrationScreen: (context) =>
      const SubmitDemonstrationScreen(),
  Routes.validateSubmissionsScreen: (context) =>
      const ValidateSubmissionsScreen(),
};
