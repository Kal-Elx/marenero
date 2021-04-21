import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData get themeData {
    return ThemeData(
      primaryColor: Colors.black,
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.white,
      canvasColor: Colors.black,
      appBarTheme: AppBarTheme(brightness: Brightness.dark),
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        //* Heading
        headline1: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        //* Text Heading
        headline2: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        //* Body Text
        bodyText1: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
        //* Emphasised Ingress
        bodyText2: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
