import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_save/auth/auth_gate.dart';
import 'package:food_save/auth/login_or_register.dart';
import 'package:food_save/pages/login_page.dart';
import 'package:food_save/pages/register_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
