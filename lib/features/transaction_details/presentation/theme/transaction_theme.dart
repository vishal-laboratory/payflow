import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionTheme {
  // Colors
  static const Color contentPrimary = Color(0xFF1F1F1F);
  static const Color borderLight = Color(0xFFC6C6C6);
  static const Color borderFaint = Color(0xFFEAEAEA);
  static const Color borderDark = Color(0xFF909090);
 // static const Color successGreen = Color(0xFF1E8D3E); #191919  // From palette
  static const Color successGreen = Color(0xFF191919);

  static const Color background = Colors.white;

  // Typography
  static TextStyle get amountStyle => GoogleFonts.roboto(
    fontSize: 52,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
    color: contentPrimary,
    height: 1.0,
  );

  static TextStyle get currencySymbolStyle => GoogleFonts.roboto(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: contentPrimary,
    height: 1.0,
  );

  static TextStyle get receiverNameStyle => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: contentPrimary,
    height: 1.0,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: contentPrimary,
    height: 1.0, // Tight height for alignment
  );

  static TextStyle get bodySmall => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: contentPrimary,
    height: 1.33, // Disclaimer line height
  );

  static TextStyle get labelSmallBold => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: contentPrimary,
    letterSpacing: 1.0,
  );

  static TextStyle get labelSmallRegular => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: contentPrimary,
    letterSpacing: 1.0,
  );

  static TextStyle get detailUseLabel => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: contentPrimary,
    height: 1.14,
  );

  static TextStyle get detailValue => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: contentPrimary,
    height: 1.17,
  );
}
