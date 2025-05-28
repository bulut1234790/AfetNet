import 'package:afetnet/screens/emergency_contact.dart';
import 'package:afetnet/screens/forum_screen.dart';
import 'package:afetnet/screens/profile_screen.dart';
import 'package:afetnet/screens/register_screen.dart';
import 'package:afetnet/screens/sign_in_screen.dart';
import 'package:afetnet/screens/sondepremler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/forum',
      routes: {
        '/signin': (context) => SignInScreen(),
        '/register': (context) => MyWidget(),
        '/profile': (context) => AfetNetApp(),
        '/contacts': (context) => EmergencyContactsScreen(),
        '/deprem': (context) => DepremlerSayfasi(),
        '/forum': (context) => ForumScreen(),
      },
    );
  }
}
