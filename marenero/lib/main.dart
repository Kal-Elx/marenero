import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'design/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/host_screen.dart';
import 'screens/join_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marenero',
      theme: AppTheme().themeData,
      home: HomeScreen(),
      routes: {
        HostScreen.routeName: (ctx) => HostScreen(),
        JoinScreen.routeName: (ctx) => JoinScreen(),
      },
    );
  }
}
