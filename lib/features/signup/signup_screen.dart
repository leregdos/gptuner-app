import 'package:flutter/material.dart';
import 'package:gptuner/providers/auth_state.dart';
import 'package:gptuner/shared/utils/functions.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
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
                      "Sign Up",
                      style: AppTheme.getTheme().textTheme.headline3,
                    ),
                    const SizedBox(height: 50.0),
                    TextFormField(
                        validator: emailValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _usernameController,
                        decoration: InputDecoration(
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
                        validator: passwordValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 11.0),
                          hintStyle: const TextStyle(fontSize: 13.0),
                          hintText: "Create password",
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
                        style: AppTheme.getTheme().textTheme.subtitle2),
                    const SizedBox(height: 16.0),
                    TextFormField(
                        validator: (val) {
                          if (val != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 11.0),
                          hintStyle: const TextStyle(fontSize: 13.0),
                          hintText: "Confirm password",
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
                        style: AppTheme.getTheme().textTheme.subtitle2),
                    const SizedBox(height: 22.0),
                    InkWell(
                      onTap: () async {
                        // await authState.signup(
                        //     _usernameController.text,
                        //     _passwordController.text,
                        //     name,
                        //     _confirmPasswordController.text);
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
                            "Create Account",
                            style: AppTheme.getTheme().textTheme.headline4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back to Sign In",
                          style: AppTheme.getTheme().textTheme.bodyText2,
                        ),
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
