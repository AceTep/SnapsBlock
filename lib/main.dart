import 'package:flutter/material.dart';
import 'player_name_screen.dart';

void main() {
  runApp(const SnapsBlok());
}

class SnapsBlok extends StatelessWidget {
  const SnapsBlok({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snaps Blok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home:
          const SplashScreenWidget(), // Use SplashScreenWidget as the initial screen
    );
  }
}

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    // Simulacija vremena za prikaz SplashScreen-a, ovdje možete postaviti i stvarnu logiku za inicijalizaciju
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlayerNameScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Snaps Blok',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'images/logo.png',
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
