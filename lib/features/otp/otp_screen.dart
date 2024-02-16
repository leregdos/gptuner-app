import 'package:flutter/material.dart';
import 'package:gptuner/theme/app_theme.dart';
import 'package:gptuner/shared/utils/constants.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add this line
  final List<String> _otp = [
    "",
    "",
    "",
    "",
    "",
    ""
  ]; // Add this line to track OTP input
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen size
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate the optimal width for the OTP fields based on screen size
    final otpFieldWidth = screenWidth / 10;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const SizedBox(
                height: 24,
              ),
              Text('Email Verification',
                  style: AppTheme.getTheme().textTheme.displaySmall),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter the OTP code sent\n to your email address",
                style: AppTheme.getTheme().textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Card(
                  color: AppTheme.getTheme().primaryColor,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(20.0), // Adjust padding as needed
                    child: Wrap(
                      // Use Wrap instead of Row to prevent overflow
                      spacing: 10, // Spacing between each OTP field
                      alignment: WrapAlignment
                          .center, // Center the OTP fields within the Wrap
                      children: List.generate(
                          6,
                          (index) => _textFieldOTP(
                              first: index == 0,
                              last: index == 5,
                              width: otpFieldWidth, // Use the calculated width
                              index: index)),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                key: const Key("verifyButton"),
                onTap: () async {
                  if (!_otp.contains("")) {
                    // setState(() {
                    //   _isLoading = true;
                    // });
                    // await state.signup(
                    //     _emailController.text,
                    //     _passwordController.text,
                    //     _nameController.text,
                    //     _confirmPasswordController.text);
                    // setState(() {
                    //   _isLoading = false;
                    // });
                    // if (!mounted) return;
                    // if (state.isAuthenticated) {
                    // Navigator.pushNamed(context, Routes.homeScreen);
                    // }
                  }
                },
                child: Container(
                  key: const Key("verifyButtonContainer"),
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
                      color: !_otp.contains("")
                          ? AppTheme.getTheme().colorScheme.background
                          : AppTheme.getTheme().disabledColor),
                  child: Center(
                    child: Text(
                      "Verify Email",
                      style: AppTheme.getTheme().textTheme.headlineMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                "Didn't receive any code?",
                style: AppTheme.getTheme().textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                "Resend New Code",
                style: AppTheme.getTheme().textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP(
      {required bool first,
      required bool last,
      required double width,
      required int index}) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 0.8,
        child: TextFormField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _otp[index] = value;
              if (value.length == 1 && last == false) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && first == false) {
                FocusScope.of(context).previousFocus();
              }
            });
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: AppTheme.getTheme().textTheme.bodyLarge,
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 2, color: AppTheme.backgroundColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
