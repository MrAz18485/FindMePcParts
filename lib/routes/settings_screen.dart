import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/app_colors.dart';
import '../util/app_text_styles.dart';
import '../util/app_paddings.dart';
import 'package:findmepcparts/routes/profile_screen.dart';
import 'package:findmepcparts/routes/language_screen.dart';
import 'package:findmepcparts/routes/about_screen.dart';

import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Settings',
                    style: AppTextStyles.headline,
                  ),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              height: 1,
              margin: const EdgeInsets.only(left: 56),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: AppPaddings.screen,
        children: [
          _settingsTile(context, Icons.person, 'Profile', '/profile', iconColor, textColor),
          _settingsTile(context, Icons.language, 'Language', '/language', iconColor, textColor),
          ListTile(
            leading: Icon(Icons.remove_red_eye, size: 28, color: iconColor),
            title: Text('Theme', style: AppTextStyles.title.copyWith(color: textColor)),
            trailing: Switch(
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          const Divider(thickness: 1),
          _settingsTile(context, Icons.info, 'About', '/about', iconColor, textColor),
          ListTile(
            leading: Icon(Icons.logout, size: 28, color: iconColor),
            title: Text('Log Out', style: AppTextStyles.title.copyWith(color: textColor)),
            onTap: () {
              // Handle logout logic here
            },
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, String route,
      Color iconColor, Color textColor) {
    return ListTile(
      leading: Icon(icon, size: 28, color: iconColor),
      title: Text(title, style: AppTextStyles.title.copyWith(color: textColor)),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}