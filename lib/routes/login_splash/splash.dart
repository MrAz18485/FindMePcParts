import 'package:findmepcparts/services/auth_provider.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    Future.delayed(const Duration(seconds: 2), () {
      print(auth.currentUser?.uid); // returns null when user is not logged in. For debugging
      if (auth.currentUser == null)
      {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
      else
      {
        Navigator.pushReplacementNamed(context, "/builder");
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.brown],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                  child: Image.asset(
                    "assets/goblin.png",
                    width: 300,  
                    height: 300,
                    fit: BoxFit.cover, 
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                "PC GOBLIN",
                style: logoTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}