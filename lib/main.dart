import 'package:flutter/material.dart';
import 'package:mobile_inventory_system/colors.dart';
import 'package:mobile_inventory_system/string.dart';
import 'package:mobile_inventory_system/screens/HomePage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.title,
      theme: ThemeData(primaryColor: AppColors.primaryColor),
      home: const HomePage(),
    );
  }
}
