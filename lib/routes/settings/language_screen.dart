import 'package:findmepcparts/util/colors.dart';
import 'package:flutter/material.dart';
import '../../util/text_styles.dart';
import '../../util/paddings.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text("Languages", style: appBarTitleTextStyle,),
          iconTheme: IconThemeData(
            color: iconColor, ),
          backgroundColor: AppColors.appBarBackgroundColor,
          elevation: 0,
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
          _languageTile(Icons.language, 'Turkish', iconColor, textColor),
          _languageTile(Icons.language, 'English', iconColor, textColor),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  Widget _languageTile(IconData icon, String text, Color? iconColor, Color textColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: iconColor, size: 28),
      title: Text(text, style: TextStyle(fontSize: 20, color: textColor)),
      onTap: () {
        // handle language selection
      },
    );
  }
}