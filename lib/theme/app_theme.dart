import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Surfaces, from deepest to most raised (shared look with the admin panel).
  static const Color baseColor = Color(0xff111316);
  static const Color primary = Color(0xff181B20);
  static const Color surface = Color(0xff1F2329);
  static const Color surfaceHigh = Color(0xff282D34);
  static const Color border = Color(0xff313740);

  static const Color textPrimary = Color(0xFFEDEDED);
  static const Color secondary = Color(0xff8A9099);

  // Easy Life gold accent.
  static const Color gold = Color(0xffE1B767);
  static const Color goldDeep = Color(0xffB8893B);
  static const Color danger = Color(0xffE5484D);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xffF0D08E), gold, goldDeep],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Frosted glass panel used for cards and sheets.
  static BoxDecoration glass({double radius = 22, bool highlighted = false}) => BoxDecoration(
        color: surface.withOpacity(0.72),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: highlighted ? gold.withOpacity(0.55) : Colors.white.withOpacity(0.07)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 10))],
      );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppTheme.primary,
    scaffoldBackgroundColor: AppTheme.baseColor,
    colorScheme: const ColorScheme.dark(
      primary: gold,
      onPrimary: Colors.black,
      secondary: gold,
      surface: surface,
      onSurface: textPrimary,
      error: danger,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: gold),
    textSelectionTheme: TextSelectionThemeData(cursorColor: gold, selectionColor: gold.withOpacity(0.3), selectionHandleColor: gold),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: border)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? gold : Colors.transparent),
      checkColor: WidgetStateProperty.all(Colors.black),
      side: const BorderSide(color: secondary, width: 1.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.black : secondary),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? gold : surfaceHigh),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: Colors.black,
        elevation: 0,
        textStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.6),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceHigh,
      contentTextStyle: GoogleFonts.poppins(color: textPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      color: AppTheme.baseColor,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
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
          foregroundColor: AppTheme.gold, textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: surfaceHigh.withOpacity(0.55),
      prefixIconColor: secondary,
      suffixIconColor: secondary,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: border)),
      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: gold, width: 1.4)),
      hintStyle: GoogleFonts.poppins(color: secondary, fontSize: 15, fontWeight: FontWeight.w400),
    ),
  );
}
