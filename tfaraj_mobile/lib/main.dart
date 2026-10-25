import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization will be enabled once the platform-specific configuration
  // (google-services.json / GoogleService-Info.plist) is verified and added.
  // await Firebase.initializeApp();
  runApp(const TfajApp());
}

class TfajApp extends StatelessWidget {
  const TfajApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFARAJ',
      debugShowCheckedModeBanner: false,
      // TFARAJ Branding: Dark Theme by Default
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF09090D),
        scaffoldBackgroundColor: const Color(0xFF09090D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4ECDC4),
          brightness: Brightness.dark,
          background: const Color(0xFF09090D),
        ),
        fontFamily: 'Tajawal', // Matches the web app font
      ),
      // Arabic RTL Layout Support
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ar', 'SA'),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Logo.png
            const Text(
              'TFARAJ',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color(0xFF4ECDC4),
            ),
            const SizedBox(height: 40),
            const Text(
              'عالمك السينمائي',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
