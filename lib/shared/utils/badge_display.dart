import 'package:flutter/material.dart';
import 'package:gptuner/theme/app_theme.dart';

class BadgeDisplay extends StatelessWidget {
  final String imagePath;
  final String badgeName;

  const BadgeDisplay({
    Key? key,
    required this.imagePath,
    required this.badgeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, width: 50), // Adjust size as needed
          Text(badgeName, style: AppTheme.getTheme().textTheme.headlineLarge),
        ],
      ),
    );
  }
}
