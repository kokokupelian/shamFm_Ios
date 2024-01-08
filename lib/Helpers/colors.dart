import 'package:flutter/material.dart';

bool isDark(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Color? ThemeShadowDark(BuildContext context) {
  return isDark(context) ? Color(0xFF232424) : null;
}

Color? ThemeShadowLight(BuildContext context) {
  return isDark(context) ? Color(0xFF373a3a) : null;
}
