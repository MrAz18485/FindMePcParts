import 'package:findmepcparts/util/colors.dart';
import 'package:flutter/material.dart';
import '../../util/text_styles.dart';
import '../../util/paddings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: PreferredSize(
        
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.appBarBackgroundColor,
          elevation: 0,
          title: Text('About', style: appBarTitleTextStyle),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: AppColors.appBarBackgroundColor,
              height: 1,
              
              margin: const EdgeInsets.only(left: 56),
            ),
          ),
        ),
      ),
      body: Center(
        child: ListView(
        padding: AppPaddings.screen,
        children: [
          Text('App Name: PC Goblin', style: bodyTitleStyle),
          const SizedBox(height: 12),
          Text(
            'PC Goblin is an upcoming mobile app for the Turkey region that helps users compare PC components, track prices, and check compatibility to build their ideal PC.',
            style: bodyTextStyle,
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 1),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: bodyTextStyle,
              children: [
                TextSpan(text: 'Build Version: ', style: bodyTextStyle),
                TextSpan(text: '[Version Number]'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: bodyTextStyle,
              children: [
                TextSpan(text: 'Creators: ', style: bodyTextStyle),
                TextSpan(text: '[Creator Names or Team Name]'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1),
        ],
      ),)
    );
  }
}