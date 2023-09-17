import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = const Color(0xFF73E7E0); //Color(0xFF4FBE9F);
  static Color accentColor = const Color(0xFFE1E9F1);
  static Color secondary = Colors.black;

  static TextTheme _buildTextTheme(TextTheme base) {
    String fontName1 = "SourceSansPro-Regular";
    String fontName2 =
        "Poppins"; // used for intro screen heading and subheading

    return base.copyWith(
      // Had to specify the fontSize manually here because didn't work.
      bodyText1: base.bodyText1!.copyWith(fontFamily: fontName1),
      bodyText2: base.bodyText2!.copyWith(fontFamily: fontName1),
      headline1: base.headline1!.copyWith(
          fontFamily: fontName1,
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight
              .w500), // Since we don't use headline1 in our code, maybe we can make it subtitle 1, but bold?
      headline2: base.headline2!.copyWith(
          fontFamily: fontName2, fontSize: 48, fontWeight: FontWeight.w500),
      headline3: base.headline3!.copyWith(
          fontFamily: fontName2, fontSize: 18, fontWeight: FontWeight.bold),
      headline4: base.headline4!.copyWith(fontFamily: fontName1, fontSize: 34),
      headline5: base.headline5!.copyWith(fontFamily: fontName1, fontSize: 24),
      headline6: base.headline6!.copyWith(fontFamily: fontName1, fontSize: 20),
      subtitle1: base.subtitle1!.copyWith(fontFamily: fontName2, fontSize: 16),
      subtitle2: base.subtitle2!.copyWith(fontFamily: fontName1, fontSize: 14),
      button: base.button!
          .copyWith(fontFamily: fontName1, fontSize: 16, color: Colors.white),
      caption: base.caption!.copyWith(fontFamily: fontName1),
      overline: base.overline!.copyWith(fontFamily: fontName1),
    );
  }

  static ThemeData getTheme() {
    return newLightTheme();
  }

  static ThemeData newLightTheme() {
    Color primaryColor = primary;
    Color secondaryColor = secondary;
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      cardColor: Colors.black,
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      canvasColor: Colors.white,
      backgroundColor: const Color(0xFFFFFFFF),
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      errorColor: const Color(0xFFf05545),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      platform: TargetPlatform.iOS,
      visualDensity: VisualDensity.adaptivePlatformDensity,
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
