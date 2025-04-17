import 'package:flutter/material.dart';
import '../util/app_text_styles.dart';
import '../util/app_paddings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: theme.scaffoldBackgroundColor,
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
                  Text('About', style: AppTextStyles.headline),
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
          Text('App Name: PC Goblin', style: AppTextStyles.title),
          const SizedBox(height: 12),
          Text(
            'PC Goblin is an upcoming mobile app for the Turkey region that helps users compare PC components, track prices, and check compatibility to build their ideal PC.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 1),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: AppTextStyles.body,
              children: const [
                TextSpan(text: 'Build Version: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '[Version Number]'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: AppTextStyles.body,
              children: const [
                TextSpan(text: 'Creators: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '[Creator Names or Team Name]'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}