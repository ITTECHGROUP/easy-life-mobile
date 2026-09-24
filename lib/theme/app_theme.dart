import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xff1A1E23);
  static const Color textPrimary = Color(0xFFE7E7E7);
  static const Color secondary = Color(0xff75797E);

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppTheme.primary,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      color: AppTheme.primary,
      elevation: 0,
    ),
    textTheme: TextTheme(
      labelSmall: GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
      ),
      displayLarge: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal,
        color: AppTheme.textPrimary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal,
        color: AppTheme.textPrimary,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        color: Colors.white,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: AppTheme.textPrimary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: AppTheme.textPrimary,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: AppTheme.textPrimary,
      ),
    ).apply(
      displayColor: AppTheme.textPrimary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: AppTheme.textPrimary, textStyle: const TextStyle(decoration: TextDecoration.underline)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(14),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.secondary,
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.secondary,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppTheme.secondary,
        ),
      ),
      hintStyle: TextStyle(
        color: AppTheme.secondary,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      filled: false,
    ),
  );
}
