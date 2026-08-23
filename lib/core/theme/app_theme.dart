import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData createTheme({required Brightness brightness, required Color primaryColor}) {
    final isDark = brightness == Brightness.dark;
    
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? const Color(0xFF0A0A0A) : AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: AppColors.secondary,
        surface: isDark ? const Color(0xFF1A1A1A) : AppColors.cardBackground,
        onSurface: isDark ? Colors.white : AppColors.textPrimary,
        onSurfaceVariant: isDark ? Colors.white70 : AppColors.textSecondary,
        brightness: brightness,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).apply(
        bodyColor: isDark ? Colors.white : AppColors.textPrimary,
        displayColor: isDark ? Colors.white : AppColors.textPrimary,
      ).copyWith(
        headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: -1.5, color: isDark ? Colors.white : AppColors.textPrimary),
        headlineMedium: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: -1.0, color: isDark ? Colors.white : AppColors.textPrimary),
        headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.bold, letterSpacing: -0.5, color: isDark ? Colors.white : AppColors.textPrimary),
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: isDark ? Colors.white : AppColors.textPrimary),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: isDark ? Colors.white : AppColors.textPrimary),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.white70 : AppColors.textSecondary),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1E1E1E) : AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: (isDark ? Colors.white : Colors.grey).withValues(alpha: 0.1)),
        ),
        shadowColor: AppColors.shadow,
      ),
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
      dividerTheme: DividerThemeData(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
