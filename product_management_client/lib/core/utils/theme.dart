import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontSize {
  static const double extraSmall = 10.0;
  static const double small = 12.0;
  static const double regular = 14.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 28.0;
}

class DefaultColors {
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF9FBFC);

  static const Color titleText = Color(0xFF000000);
  static const Color subtitleText = Color(0xFFBDBFC0);
  static const Color highlightTitle = Color(0xFF61BD50);

  static const Color buttonColor = Color(0xFF53B175);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: DefaultColors.background,
      cardColor: DefaultColors.cardBackground,
      primaryColor: DefaultColors.buttonColor,
      fontFamily: GoogleFonts.inter().fontFamily,

      appBarTheme: AppBarTheme(
        backgroundColor: DefaultColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: DefaultColors.titleText),
        titleTextStyle: GoogleFonts.inter(
          fontSize: FontSize.large,
          fontWeight: FontWeight.w600,
          color: DefaultColors.titleText,
        ),
      ),

      textTheme: TextTheme(
        titleLarge: GoogleFonts.inter(
          fontSize: FontSize.large,
          fontWeight: FontWeight.w600,
          color: DefaultColors.titleText,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w500,
          color: DefaultColors.titleText,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: FontSize.medium,
          fontWeight: FontWeight.normal,
          color: DefaultColors.subtitleText,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: FontSize.regular,
          fontWeight: FontWeight.normal,
          color: DefaultColors.subtitleText,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: FontSize.small,
          fontWeight: FontWeight.normal,
          color: DefaultColors.subtitleText,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DefaultColors.buttonColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.inter(
            fontSize: FontSize.medium,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
