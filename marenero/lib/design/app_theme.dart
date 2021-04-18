import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      textTheme: GoogleFonts.latoTextTheme(),
    );
  }
}
