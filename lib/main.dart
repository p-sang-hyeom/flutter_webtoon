import 'package:flutter/material.dart';
import 'package:toonflix/screens/home_screen.dart';
import 'package:toonflix/screens/liked_screen.dart';
import 'package:toonflix/screens/recent_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '미소숯불닭갈비',
      home: AnimatedSplashScreen(
        splash: Image.asset('Assets/image/Keybase.png'),
        nextScreen: const AppScreen(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

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
