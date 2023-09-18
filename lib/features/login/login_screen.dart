import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gptuner/shared/utils/constants.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _passwordValidationError = false;

  _login() {
    // Here you'll eventually make the API call to authenticate.
    // For now, just print the entered username and password.
    print("Username: ${_usernameController.text}");
    print("Password: ${_passwordController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getTheme().backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Card(
            color: AppTheme.getTheme().primaryColor,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 74.0, bottom: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // const SizedBox(height: 50.0),
                    Text(
                      "Sign In",
                      style: AppTheme.getTheme().textTheme.headline3,
                    ),
                    const SizedBox(height: 50.0),
                    TextFormField(
                        validator: emailValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          errorStyle: const TextStyle(fontSize: 11.0),
                          hintStyle: const TextStyle(fontSize: 13.0),
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                22.0), // Adjust this value for your desired roundness
                            borderSide: BorderSide
                                .none, // This removes the default underline
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0),
                            borderSide: const BorderSide(
                                color: Colors
                                    .blue), // Change this color for the focused border color
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          filled: true,
                          fillColor: Colors
                              .grey[200], // This gives it a gray background
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: AppTheme.getTheme().textTheme.subtitle2),
                    const SizedBox(height: 16.0),
                    TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            _passwordValidationError = true;
                            return "Please enter your password";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          errorStyle: const TextStyle(fontSize: 11.0),
                          hintStyle: const TextStyle(fontSize: 13.0),
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                22.0), // Adjust this value for your desired roundness
                            borderSide: BorderSide
                                .none, // This removes the default underline
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0),
                            borderSide: const BorderSide(
                                color: Colors
                                    .blue), // Change this color for the focused border color
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          filled: true,
                          fillColor: Colors
                              .grey[200], // This gives it a gray background
                        ),
                        obscureText: _obscureText,
                        style: AppTheme.getTheme().textTheme.subtitle2),

                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 12.0),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                _obscureText
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                size: 14.0,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(width: 7),
                              Text(
                                "Show/Hide password",
                                style: AppTheme.getTheme().textTheme.caption,
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 22.0),
                    InkWell(
                      onTap: () {
                        _login();
                        Navigator.pushNamed(context, Routes.homeScreen);
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 200, maxWidth: double.infinity),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1.0, vertical: 18.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(17.0),
                            color: AppTheme.getTheme().backgroundColor),
                        child: Center(
                          child: Text(
                            "Login",
                            style: AppTheme.getTheme().textTheme.headline4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          print("forgot pass");
                        },
                        child: Text(
                          "Forgot Password?",
                          style: AppTheme.getTheme().textTheme.caption,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: AppTheme.getTheme().textTheme.subtitle2,
                          ),
                          const SizedBox(width: 5.0),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.signupScreen);
                            },
                            child: Text(
                              "Sign Up",
                              style: AppTheme.getTheme().textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}