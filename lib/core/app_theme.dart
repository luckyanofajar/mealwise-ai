import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData darkTheme =
      ThemeData(

    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor:
        const Color(0xff1E1E2E),

    colorScheme: const ColorScheme.dark(

      primary: Color(0xffFF7A00),

      secondary: Color(0xffFFD369),

      surface: Color(0xff2A2A40),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor:
          Color(0xff1E1E2E),

      elevation: 0,
    ),
  );
}