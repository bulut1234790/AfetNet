import 'package:afetnet/screens/duduk.dart';
import 'package:afetnet/screens/education.dart';
import 'package:afetnet/screens/emergency_contact.dart';
import 'package:afetnet/screens/forum_screen.dart';
import 'package:afetnet/screens/map_screen.dart';
import 'package:afetnet/screens/profile_screen.dart';
import 'package:afetnet/screens/profile_update.dart';
import 'package:afetnet/screens/register_screen.dart';
import 'package:afetnet/screens/settings.dart';
import 'package:afetnet/screens/settings_notifier.dart';
import 'package:afetnet/screens/sign_in_screen.dart';
import 'package:afetnet/screens/sondepremler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsNotifier()),
        // başka ChangeNotifier'lar da buraya eklenebilir
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsNotifier>(context);
    return MaterialApp(
      theme: settings.currentTheme,
      title: 'My App',
      initialRoute: '/forum',
      routes: {
        '/signin': (context) => SignInScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => ProfileScreen(),
        '/contacts': (context) => EmergencyContactsScreen(),
        '/deprem': (context) => DepremlerSayfasi(),
        '/forum': (context) => ForumScreen(),
        '/egitim': (context) => EducationPage(),
        '/profile_update': (context) => ProfileUpdateScreen(),
        '/duduk': (context) => DudukSayfasi(),
        '/anasayfa': (context) => MapScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
