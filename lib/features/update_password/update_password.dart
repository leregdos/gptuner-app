import 'package:flutter/material.dart';
import 'package:gptuner/shared/widgets/custom_loader.dart';
import 'package:gptuner/theme/app_theme.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isValidForm = false;
  void _updateFormValidation() {
    setState(() {
      _isValidForm = _formKey.currentState!.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8AA1A9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8AA1A9),
        title: Text(
          'Update Password',
          style: AppTheme.getTheme().textTheme.headline1,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 48.0, right: 48.0, top: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                            onChanged: (value) => _updateFormValidation(),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(fontSize: 11.0),
                              hintStyle: const TextStyle(fontSize: 13.0),
                              hintText: "Enter your current password",
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
                            obscureText: true,
                            style: AppTheme.getTheme().textTheme.subtitle2),
                        const SizedBox(height: 16.0),
                        TextFormField(
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter your new password";
                              }
                              return null;
                            },
                            onChanged: (value) => _updateFormValidation(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _newPasswordController,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(fontSize: 11.0),
                              hintStyle: const TextStyle(fontSize: 13.0),
                              hintText: "Enter your new password",
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
                            obscureText: true,
                            style: AppTheme.getTheme().textTheme.subtitle2),
                        const SizedBox(height: 16.0),
                        TextFormField(
                            validator: (val) {
                              if (val != _newPasswordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            onChanged: (value) => _updateFormValidation(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _newPasswordConfirmController,
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(fontSize: 11.0),
                              hintStyle: const TextStyle(fontSize: 13.0),
                              hintText: "Confirm your new password",
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
                            obscureText: true,
                            style: AppTheme.getTheme().textTheme.subtitle2),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 16.0, right: 16.0),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {}
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
                            color: _isValidForm
                                ? AppTheme.getTheme().backgroundColor
                                : AppTheme.getTheme().disabledColor),
                        child: Center(
                          child: Text(
                            "Change Password",
                            style: AppTheme.getTheme().textTheme.headline4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: Positioned.fill(
              child: Container(color: Colors.grey.withOpacity(0.7)),
            ),
          ),
          Center(child: Visibility(visible: _isLoading, child: CustomLoader())),
        ],
      ),
    );
  }
}
