import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marenero/screens/guest_screen.dart';

import 'design/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/host_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        // TODO: Add route (with argument(s)!?) for GuestScreen and EnterNameScreen.
        HostScreen.routeName: (ctx) => HostScreen(),
      },
    );
  }
}
