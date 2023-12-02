import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: const Color(0xFF047E78),
    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    textTheme: TextTheme(
        bodyLarge: const TextStyle(color: Colors.white),
        bodyMedium: const TextStyle(color: Colors.white),
        displayLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 25,
          color: Colors.white,
        ),
        displayMedium: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.white,
        ),
        displaySmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.white,
        ),
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black,
        ),
        headlineSmall: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Color(0XFF525252),
        ),
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0XFF222222),
        ),
        titleMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: const Color(0XFF171A20).withOpacity(0.5),
            wordSpacing: 1.25)),
  );
}
