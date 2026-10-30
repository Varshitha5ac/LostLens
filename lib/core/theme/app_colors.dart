
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF153D3B);
  static const Color secondary = Color(0xFFA8B7A0);
  static const Color accent = Color(0xFFE56B54);
  static const Color highlight = Color(0xFFE9B44C);

  // Background Colors
  static const Color background = Color(0xFFF5F1E8);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color white = Color(0xFFFFFFFF);

  // Typography Colors
  static const Color textPrimary = Color(0xFF263432);
  static const Color textSecondary = Color(0xFF77847B);

  // Border and Divider
  static const Color border = Color(0xFFE5E1D8);
  static const Color divider = Color(0xFFECE8DF);

  // Item Status Colors
  static const Color lost = Color(0xFFE56B54);
  static const Color found = Color(0xFF153D3B);
  static const Color pending = Color(0xFFE9B44C);
  static const Color approved = Color(0xFFA8B7A0);
  static const Color rejected = Color(0xFFCF625D);
  static const Color returned = Color(0xFF153D3B);

  // Utility Colors
  static const Color error = Color(0xFFCF3F3F);
  static const Color success = Color(0xFF38845B);

  // Compatibility aliases used by screens
  static const Color evergreen = primary;
  static const Color sage = secondary;
  static const Color coral = accent;
  static const Color marigold = highlight;

  static const Color paper = background;
  static const Color charcoal = textPrimary;
  static const Color muted = textSecondary;
}
