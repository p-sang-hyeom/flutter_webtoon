import 'package:flutter/material.dart';
import 'package:toonflix/screens/home_screen.dart';
import 'package:toonflix/screens/liked_screen.dart';
import 'package:toonflix/screens/recent_screen.dart';
import 'package:toonflix/services/api_services.dart';

void main() {
  ApiService.getKeymediMainContent();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: HomeScreen(),
      color: Colors.white,
      initialRoute: '/0',
      routes: {
        '/0': (context) => const HomeScreen(),
        '/1': (context) => const LikedScreen(),
        '/2': (context) => const RecentScreen()
      },
    );
  }
}
