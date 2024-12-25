import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory_system/colors.dart';
import 'package:mobile_inventory_system/screens/LoginPage.dart';
import 'package:mobile_inventory_system/string.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.title,
      theme: ThemeData(primaryColor: AppColors.primaryColor),
      home: const LoginPage(),
    );
  }
}
