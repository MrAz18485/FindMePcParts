import 'package:findmepcparts/routes/guides/guides.dart';
import 'package:findmepcparts/routes/community/community.dart';
import 'package:findmepcparts/routes/builder/build_page.dart';
import 'package:findmepcparts/routes/login_splash/forgot_password.dart';
import 'package:findmepcparts/routes/login_splash/login_screens.dart';
import 'package:findmepcparts/routes/login_splash/splash.dart';

import 'package:findmepcparts/routes/sales/sales.dart';

import 'package:findmepcparts/firebase_options.dart';
import 'package:findmepcparts/services/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';



import 'routes/settings/settings_screen.dart';
import 'routes/settings/profile_screen.dart';
import 'routes/settings/change_details_screen.dart';

import 'routes/settings/about_screen.dart';

import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // don't start app until framework is booted completely
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (_) => AuthService(),
    child: MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    final auth = Provider.of<AuthService>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ← bu satırı ekle
      initialRoute: '/splash',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // themeMode: themeProvider.themeMode,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const LoginChoiceScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => ProfileSetupScreen(),
        '/sales': (context) =>  const OnSale(),
        '/settings': (context) =>  ChangeNotifierProvider(create: (_) => ThemeProvider(), child: SettingsScreen()),
        '/profile': (context) => const ProfileScreen(),
        '/changeDetails': (context) => const ChangeDetailsScreen(),
        '/about': (context) => const AboutScreen(),

        '/builder': (context) =>  const NBuildPage(),
        '/forgotpassword': (context) => ForgotPasswordScreen(),
        
        '/guides': (context) =>  const Guides(),
        '/guidesDetails': (context) => const GuidesDetailScreen(),
        '/community': (context) => const Community(),
        '/communityDetails': (context) => const CommunityDetailScreen(),
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




