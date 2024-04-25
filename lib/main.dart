import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:reciper/screens/pages_layout.dart';
import 'screens/home.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'theme.dart';

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Reciper',
        theme: catppuccinTheme(catppuccin.macchiato),
        home: const PagesLayout(child: HomePage()));
  }
}
