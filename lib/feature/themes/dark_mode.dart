import 'package:flutter/material.dart';
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF081A17),        // još tamnija pozadina
    primary: const Color(0xFF0F2622),        // card/container površine
    secondary: const Color(0xFF174038),      // istaknuti elementi
    tertiary: const Color(0xFF2EBFB0),       // akcijska boja — svjetliji teal
    inversePrimary: const Color(0xFFCCFFF9), // tekst / naslovi — gotovo bijelo
  ),
  scaffoldBackgroundColor: const Color(0xFF081A17),
);
