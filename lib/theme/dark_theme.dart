import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme_colors.dart';
import 'theme_constants.dart';

const _navigationBarStyle = TextStyle(
  fontSize: 12,
  letterSpacing: 0,
  fontWeight: FontWeight.w600,
);

/// Темная тема
final darkThemeData = ThemeData(
  scaffoldBackgroundColor: kDarkBackgroundColor,
  fontFamily: "SFProDisplay",
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: kLightTextPrimaryColor,
    ),
    backgroundColor: kDarkBackgroundColor,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: kDarkTextPrimaryColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kPrimaryColor,
    foregroundColor: kLightBackgroundColor,
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 64,
      fontWeight: FontWeight.w900,
      letterSpacing: -1.5,
      color: kDarkTextPrimaryColor,
    ),
    displayMedium: const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      color: kDarkTextPrimaryColor,
    ),
    displaySmall: const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: kDarkTextPrimaryColor,
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.25,
      color: kDarkTextPrimaryColor,
    ),
    headlineSmall: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: kDarkTextPrimaryColor,
    ),
    titleLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: kDarkTextPrimaryColor,
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: kDarkTextPrimaryColor,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: kDarkTextSecondaryColor,
    ),
    labelLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.25,
      color: kDarkTextPrimaryColor,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: kDarkTextSecondaryColor,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: kDarkTextPrimaryColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: kDarkTextSecondaryColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: kDarkTextSecondaryColor,
    ),
  ),
  primaryColor: kPrimaryColor,
  primaryColorLight: kPrimaryLightColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    showUnselectedLabels: true,
    selectedLabelStyle: _navigationBarStyle.copyWith(color: kPrimaryLightColor),
    unselectedLabelStyle: _navigationBarStyle.copyWith(color: kGray1Color),
    type: BottomNavigationBarType.fixed,
    backgroundColor: kDarkBackgroundColor,
    selectedItemColor: kPrimaryLightColor,
    unselectedItemColor: kGray1Color,
    selectedIconTheme: const IconThemeData(
      color: kPrimaryColor,
    ),
    unselectedIconTheme: const IconThemeData(
      color: kGray1Color,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kPrimaryColor,
    selectionColor: kPrimaryColor.withOpacity(0.25),
    selectionHandleColor: kPrimaryColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorMaxLines: 4,
    floatingLabelStyle: const TextStyle(
      fontSize: 16,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w600,
      color: kDarkTextPrimaryColor,
    ),
    labelStyle: const TextStyle(
      fontSize: 16,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w600,
      color: kDarkTextPrimaryColor,
    ),
    errorStyle: const TextStyle(
      fontSize: 14,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w400,
      color: kRedColor,
    ),
    hintStyle: TextStyle(
      fontSize: 16,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w400,
      color: kDarkTextSecondaryColor.withOpacity(0.5),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: kRedColor.withOpacity(0.5),
        width: 2,
      ),
      borderRadius: kBorderRadius,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: kRedColor.withOpacity(0.5),
        width: 2,
      ),
      borderRadius: kBorderRadius,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: kDarkTextSecondaryColor.withOpacity(0.25),
        width: 2,
      ),
      borderRadius: kBorderRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: kPrimaryColor.withOpacity(0.25),
        width: 2,
      ),
      borderRadius: kBorderRadius,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: kBorderRadius,
    ),
    backgroundColor: kDarkBackgroundSecondaryColor,
    contentTextStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      color: kDarkTextPrimaryColor,
    ),
  ),
  cardTheme: CardTheme(
    color: kDarkBackgroundSecondaryColor,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);
