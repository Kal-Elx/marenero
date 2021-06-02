import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData get themeData {
    return ThemeData(
      primarySwatch: Colors.teal,
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.white,
      canvasColor: Colors.black,
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      textButtonTheme: TextButtonThemeData(),
      dividerTheme: DividerThemeData(
        color: Colors.white24,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(12.0),
          minimumSize: Size(
            200.0,
            50.0,
          ),
          primary: Colors.white,
          side: BorderSide(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
      ),
      textTheme: GoogleFonts.latoTextTheme().copyWith(
        //* Heading
        headline1: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        //* Text Heading
        headline2: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        //* Text Subheading
        headline3: TextStyle(
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
          fontSize: 12.0,
        ),
      ),
    );
  }
}
