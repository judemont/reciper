import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';

ThemeData catppuccinTheme(Flavor flavor) {
  Color primaryColor = flavor.mauve;
  Color secondaryColor = flavor.pink;
  return ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: flavor.text),
          elevation: 0,
          titleTextStyle: TextStyle(
              color: flavor.text, fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: flavor.crust,
          foregroundColor: flavor.mantle),
      colorScheme: ColorScheme(
        background: flavor.base,
        brightness: Brightness.light,
        error: flavor.surface2,
        onBackground: flavor.text,
        onError: flavor.red,
        onPrimary: primaryColor,
        onSecondary: secondaryColor,
        onSurface: flavor.text,
        primary: flavor.crust,
        secondary: flavor.mantle,
        surface: flavor.surface0,
      ),
      textTheme: const TextTheme().apply(
        bodyColor: flavor.text,
        displayColor: flavor.text,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        foregroundColor: flavor.text,
      )),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: flavor.text)),
      hintColor: flavor.text,
      listTileTheme: ListTileThemeData(
          selectedColor: flavor.text, selectedTileColor: flavor.mantle),
      splashColor: flavor.mantle,
      highlightColor: flavor.crust,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
      ));
}
