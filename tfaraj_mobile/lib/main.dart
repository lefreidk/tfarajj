import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Attempt Firebase initialization
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization skipped or failed: $e');
  }
  runApp(const TfajApp());
}

class TfajApp extends StatefulWidget {
  const TfajApp({super.key});

  @override
  State<TfajApp> createState() => _TfajAppState();
}

class _TfajAppState extends State<TfajApp> {
  Locale _locale = const Locale('ar', 'SA');

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFARAJ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      home: HomeScreen(onLanguageChanged: _setLocale),
    );
  }
}
