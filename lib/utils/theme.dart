import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette berdasarkan gambar dengan background putih
  static const Color primaryColor = Color(0xFF6B8E23); // Olive green untuk button
  static const Color secondaryColor = Color(0xFFA0522D); // Sienna brown untuk link
  static const Color accentColor = Color(0xFFD2691E); // Chocolate brown
  static const Color darkColor = Color(0xFF1A1A1A); // Hitam pekat untuk teks utama
  static const Color lightColor = Color(0xFFF8F9FA); // Abu-abu sangat muda untuk elemen sekunder
  static const Color backgroundColor = Colors.white; // PUTIH bersih untuk background
  static const Color surfaceColor = Colors.white; // PUTIH untuk kartu dan input
  static const Color textPrimary = Color(0xFF1A1A1A); // Hitam untuk teks utama
  static const Color textSecondary = Color(0xFF666666); // Abu-abu untuk teks sekunder
  
  // Gradients (natural earthy tones)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B8E23), Color(0xFF8FBC8F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFA0522D), Color(0xFFD2691E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Untuk backward compatibility
  static const Color primaryGreen = primaryColor;
  static const Color darkBrown = darkColor;
  static const Color lightCream = Color(0xFFF8F9FA);
  static const Color accentGreen = Color(0xFF8FBC8F);

  static ThemeData get lightTheme {
    return ThemeData(
      // Basic configuration
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor, // PUTIH
      fontFamily: 'Roboto',
      brightness: Brightness.light,
      
      // Color Scheme untuk Material 3 compatibility
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor, // PUTIH
        background: backgroundColor, // PUTIH
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      
      // App Bar Theme - putih dengan teks gelap
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor, // PUTIH
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Elevated Button Theme - hijau olive pada putih
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          backgroundColor: surfaceColor, // PUTIH
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      
      // Input Theme - putih dengan border abu-abu
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor, // PUTIH
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF9E9E9E),
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFE53935),
          fontSize: 12,
        ),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.grey[300]!;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(color: Colors.grey, width: 1.5),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      
      // Text Theme untuk kontras optimal di background putih
      textTheme: const TextTheme(
        // Judul besar "Daftar" - Hitam pekat
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        
        // Subjudul "Buat akun baru Anda di Nuju Coffee" - Abu-abu
        displayMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.4,
        ),
        
        // Label field seperti "Nama Lengkap" - Hitam
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        
        // Label checkbox - Hitam
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        
        // Text biasa - Hitam
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        
        // Text kecil/helper text - Abu-abu
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.4,
        ),
        
        // Link text seperti "Masuk di sini" - Coklat
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: secondaryColor,
          decoration: TextDecoration.underline,
          decorationColor: secondaryColor,
        ),
        
        // Button text - Putih
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        
        // Small label - Abu-abu muda
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9E9E9E),
        ),
      ),
      
      // Divider Theme - Abu-abu sangat muda
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEEEE),
        thickness: 1,
        space: 20,
      ),
      
      // Chip Theme - Abu-abu sangat muda
      chipTheme: ChipThemeData(
        backgroundColor: lightColor,
        selectedColor: primaryColor.withOpacity(0.1),
        labelStyle: const TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      
      // Bottom Sheet Theme - Putih
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceColor, // PUTIH
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        elevation: 8,
      ),
      
      // Floating Action Button Theme - Hijau olive
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    
    );
  }
}