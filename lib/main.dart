import 'package:flutter/material.dart';

// 1) Firebase paketleri
import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseOptions;

// 2) Provider
import 'package:provider/provider.dart';

// 3) Mevcut screen/routes import’ların
import 'package:findmepcparts/routes/login_splash/splash.dart';
import 'package:findmepcparts/routes/login_splash/login_screens.dart';
import 'package:findmepcparts/routes/sales/sales.dart';
import 'package:findmepcparts/routes/settings/settings_screen.dart';
import 'package:findmepcparts/routes/settings/profile_screen.dart';
import 'package:findmepcparts/routes/settings/change_details_screen.dart';
import 'package:findmepcparts/routes/settings/language_screen.dart';
import 'package:findmepcparts/routes/settings/about_screen.dart';
import 'package:findmepcparts/routes/builder/build_page.dart';
import 'package:findmepcparts/routes/guides/guides.dart';
import 'package:findmepcparts/routes/guides/guides_detail_screen.dart';
import 'package:findmepcparts/routes/community/community.dart';
// import 'package:findmepcparts/routes/community/community_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    // Try to initialize Firebase without options first
    await Firebase.initializeApp();
    print("Firebase initialized successfully without options");
  } catch (e) {
    print("Failed to initialize Firebase without options: $e");

    // If that fails, try with a name
    try {
      await Firebase.initializeApp(name: 'FindMePcParts');
      print("Firebase initialized with name");
    } catch (e) {
      print("Failed to initialize Firebase with name: $e");

      // If that also fails, try with default options
      try {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyDummyApiKey123456789",
            appId: "1:123456789:web:abcdef123456789",
            messagingSenderId: "123456789",
            projectId: "findmepcparts",
          ),
        );
        print("Firebase initialized with default options");
      } catch (e) {
        print("Failed to initialize Firebase with default options: $e");
        print("Continuing without Firebase initialization");
      }
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,              // artık dinamik
      routes: {
        '/splash': (c) => const SplashScreen(),
        '/welcome': (c) => const LoginChoiceScreen(),
        '/signin': (c) => const SignInScreen(),
        '/signup': (c) => const SignUpScreen(),
        '/profileSetup': (c) => const ProfileSetupScreen(),
        '/sales': (c) => const OnSale(),
        '/settings': (c) => const SettingsScreen(),
        '/profile': (c) => const ProfileScreen(),
        '/changeDetails': (c) => const ChangeDetailsScreen(),
        '/about': (c) => const AboutScreen(),
        '/language': (c) => const LanguageScreen(),
        '/builder': (c) => const NBuildPage(),
        '/guides': (c) => const Guides(),
        '/guidesDetails': (c) => const GuidesDetailScreen(),
        '/community': (c) => const Community(),
      },
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
