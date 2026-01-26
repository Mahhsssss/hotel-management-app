import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget {
  static TextStyle smalltext(Color color, double size) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w400,
      fontFamily: "Poppins",
    );
  }

  static TextStyle bodytext(Color color, double size) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w300,
      fontFamily: "Poppins",
    );
  }

  static TextStyle headingtext(Color color, double size) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w800,
      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
    );
  }

  static TextStyle headingcustomtext(Color color, double size) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w800,
      fontFamily: GoogleFonts.playfairDisplay().fontFamily,
    );
  }
}
