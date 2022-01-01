import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'design/app_theme.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart'; // generated via `flutterfire` CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marenero',
      theme: AppTheme().themeData,
      home: HomeScreen(),
    );
  }
}
