import 'package:afetnet/screens/education.dart';
import 'package:afetnet/screens/emergency_contact.dart';
import 'package:afetnet/screens/forum_screen.dart';
import 'package:afetnet/screens/profile_screen.dart';
import 'package:afetnet/screens/profile_update.dart';
import 'package:afetnet/screens/register_screen1.dart';
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
      initialRoute: '/profile',
      routes: {
        '/signin': (context) => SignInScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => ProfileScreen(),
        '/contacts': (context) => EmergencyContactsScreen(),
        '/deprem': (context) => DepremlerSayfasi(),
        '/forum': (context) => ForumScreen(),
        '/egitim': (context) => EducationPage(),
        '/profile_update': (context) => ProfileUpdateScreen(),
      },
    );
  }
}
