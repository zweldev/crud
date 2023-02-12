import 'package:flutter/material.dart';
import 'package:sqflite_crud/sqflite/view.dart';

void main() {
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SQFLITE_View(),
    );
  }
}
