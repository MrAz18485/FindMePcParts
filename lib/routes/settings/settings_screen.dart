import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:findmepcparts/services/auth_provider.dart";
import '../../util/colors.dart';
import '../../util/text_styles.dart';
import '../../util/paddings.dart';
import 'package:findmepcparts/nav_bar.dart';
import '../../main.dart';
import 'package:firebase_auth/firebase_auth.dart';



class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.appBarBackgroundColor,
          elevation: 0,
          centerTitle: false,
          title:  Text(
            'Settings',
            style: appBarTitleTextStyle,
          ),
        ),
      ),
      body: ListView(
        padding: AppPaddings.screen,
        children: [
          Divider(color: Colors.black,),

          ListTile(
            leading: Icon(Icons.person, size: 28, color: iconColor),
            title: Text('Profile', style: settingsTitle.copyWith(color: textColor)),
            onTap: () {
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.pushNamed(context, '/profile');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please log in to view your profile.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          
          Divider(color: Colors.black,),
          _settingsTile(context, Icons.info, 'About', '/about', iconColor, textColor),
          FirebaseAuth.instance.currentUser != null
              ? ListTile(
            leading: Icon(Icons.logout, size: 28, color: iconColor),
            title: Text('Log Out', style: settingsTitle.copyWith(color: textColor)),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false,);   // successful login
            },
          )
              : ListTile(
            leading: Icon(Icons.login, size: 28, color: iconColor),
            title: Text('Log In', style: settingsTitle.copyWith(color: textColor)),
            onTap: () async {
              Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false,);
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, String route,
      Color iconColor, Color textColor) {
    return ListTile(
      leading: Icon(icon, size: 28, color: iconColor),
      title: Text(title, style: settingsTitle.copyWith(color: textColor)),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}