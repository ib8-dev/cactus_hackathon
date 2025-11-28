import 'package:flutter/material.dart';
import 'package:flutter_intent/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  checkDownload() async {}

  @override
  Widget build(BuildContext context) {
    final Color textColor = Colors.grey[900]!;

    final nothingTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: Colors.black,
        secondary: Color(0xFFD71920), // Nothing's Red
        surface: Colors.white,
        background: Colors.white,
        onPrimary:
            Colors.white, // Text on primary color (black) should be white
        onSecondary:
            Colors.white, // Text on secondary color (red) should be white
        onSurface:
            textColor, // Text on surface color (white) should be dark grey
        onBackground:
            textColor, // Text on background color (white) should be dark grey
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 48,
        ),
        displayMedium: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 36,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 20,
        ),

        // Default body and title text styles
        bodyLarge: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        bodyMedium: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        bodySmall: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        titleMedium: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        titleSmall: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
        labelLarge: TextStyle(fontFamily: 'IBMPlexMono', color: textColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'DotGothic16',
          color: textColor,
          fontSize: 22,
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFD71920),
        unselectedItemColor: textColor,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      iconTheme: IconThemeData(color: textColor),
    );

    return MaterialApp(
      title: 'Flutter Intent',
      theme: nothingTheme,
      darkTheme:
          nothingTheme, // Still providing a darkTheme for completeness, but themeMode.light will override.
      themeMode: ThemeMode.light,
      home: const OnboardingScreen(),
    );
  }
}
