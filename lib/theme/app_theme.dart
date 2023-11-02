import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = const Color(0xFFFFFFFF); //Color(0xFF4FBE9F);
  static Color backgroundColor = const Color(0xFF73E7E0); //Color(0xFF4FBE9F);
  static Color accentColor = const Color(0xFFE1E9F1);

  static TextTheme _buildTextTheme(TextTheme base) {
    String fontName2 =
        "Poppins"; // used for intro screen heading and subheading

    return base.copyWith(
      bodyLarge: base.bodyLarge!.copyWith(fontFamily: fontName2),
      // Don't touch below
      bodyMedium: base.bodyMedium!.copyWith(
          fontFamily: fontName2,
          fontSize: 14,
          color: const Color(0xFF73E7E0),
          fontWeight: FontWeight.w500,
          letterSpacing: -0.333),
      displayLarge: base.displayLarge!.copyWith(
          fontFamily: fontName2,
          fontSize: 18,
          color: const Color(0xFFFFFFFF),
          letterSpacing: -0.333,
          fontWeight: FontWeight.w600),
      displayMedium: base.displayMedium!.copyWith(
          fontFamily: fontName2, fontSize: 48, fontWeight: FontWeight.w500),
      displaySmall: base.displaySmall!.copyWith(
          fontFamily: fontName2,
          fontSize: 17,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.333),
      headlineMedium: base.headlineMedium!.copyWith(
        fontFamily: fontName2,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: base.headlineSmall!.copyWith(
          fontFamily: fontName2,
          fontSize: 20,
          color: const Color(0xFFFFFFFF),
          fontWeight: FontWeight.w500,
          letterSpacing: -0.333),
      titleLarge: base.titleLarge!.copyWith(
          fontFamily: fontName2,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.333),
      titleMedium:
          base.titleMedium!.copyWith(fontFamily: fontName2, fontSize: 14),
      // don't touch below
      titleSmall: base.titleSmall!.copyWith(
          fontFamily: fontName2,
          fontSize: 14,
          letterSpacing: -0.333,
          fontWeight: FontWeight.w400),
      labelLarge: base.labelLarge!
          .copyWith(fontFamily: fontName2, fontSize: 16, color: Colors.white),
      bodySmall: base.bodySmall!.copyWith(
          fontFamily: fontName2,
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.333),
      labelSmall: base.labelSmall!.copyWith(fontFamily: fontName2),
      labelMedium: base.labelMedium!.copyWith(
          fontFamily: fontName2,
          fontSize: 16,
          color: const Color(0xFF73E7E0),
          fontWeight: FontWeight.w500,
          letterSpacing: -0.333),
    );
  }

  static ThemeData getTheme() {
    return newLightTheme();
  }

  static ThemeData newLightTheme() {
    Color primaryColor = primary;
    Color secondaryColor = backgroundColor;
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      background: secondaryColor,
      error: const Color(0xFFf05545),
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      disabledColor: Colors.grey,
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      platform: TargetPlatform.iOS,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardColor: const Color(0xFF1C1C1E),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
