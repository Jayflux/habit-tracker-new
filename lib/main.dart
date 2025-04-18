import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_databases.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/login_page.dart';
import 'package:habit_tracker/pages/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';


  final HabitDatabases db = HabitDatabases();


void main() async {
  await Hive.initFlutter();
  await Hive.openBox("Habit_Database");
  setup();
  runApp(const MyApp());
}

  Future<void> setup() async {
    await db.init();
  }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
