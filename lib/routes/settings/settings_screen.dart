import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:findmepcparts/services/auth_provider.dart";
import '../../util/colors.dart';
import '../../util/text_styles.dart';
import '../../util/paddings.dart';
import 'package:findmepcparts/nav_bar.dart';
import '../../main.dart';



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

          _settingsTile(context, Icons.person, 'Profile', '/profile', iconColor, textColor),
          _settingsTile(context, Icons.language, 'Language', '/language', iconColor, textColor),
          ListTile(
            leading: Icon(Icons.remove_red_eye, size: 28, color: iconColor),
            title: Text('Theme', style: settingsTitle.copyWith(color: textColor)),
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          Divider(color: Colors.black,),
          _settingsTile(context, Icons.info, 'About', '/about', iconColor, textColor),
          ListTile(
            leading: Icon(Icons.logout, size: 28, color: iconColor),
            title: Text('Log Out', style: settingsTitle.copyWith(color: textColor)),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false,);   // successful login       
            },
          ),
          Divider(color: Colors.black),
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