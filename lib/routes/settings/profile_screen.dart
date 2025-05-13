import 'package:flutter/material.dart';
import '../../util/text_styles.dart';
import '../../util/paddings.dart';
import '../../util/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.appBarBackgroundColor,
          title: Text('Profile', style: appBarTitleTextStyle),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: AppColors.bodyBackgroundColor,
              height: 1,
              margin: const EdgeInsets.only(left: 56),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: AppPaddings.screen,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
              ),
              const SizedBox(height: 20),
              Text('Name Surname', style: settingsBody),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          _profileItem(Icons.info, 'username', textColor),
          _profileItem(Icons.email, 'e-mail', textColor),
          _profileItem(Icons.remove_red_eye, 'password', textColor),
          const Divider(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black, // Butonun arka plan rengi
                foregroundColor: Colors.white, // Buton metninin rengi
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/changeDetails'),
              child: const Text('Change details', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileItem(IconData icon, String label, Color color) {
    return ListTile(
      leading: Icon(icon, size: 28, color: color),
      title: Text(label, style: TextStyle(fontSize: 18, color: color)),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    );
  }
}