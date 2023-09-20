import 'package:flutter/material.dart';
import 'package:gptuner/shared/utils/constants.dart';
import 'package:gptuner/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8AA1A9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8AA1A9),
        title: Text(
          'Settings',
          style: AppTheme.getTheme().textTheme.headline1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      'Update Password',
                      style: AppTheme.getTheme().textTheme.button,
                      textAlign: TextAlign.left,
                    ),
                    trailing: const Icon(
                      Icons.arrow_right_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.updatePasswordScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
