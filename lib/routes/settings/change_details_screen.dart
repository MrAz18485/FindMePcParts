import 'package:findmepcparts/util/colors.dart';
import 'package:flutter/material.dart';
import '../../util/text_styles.dart';

class ChangeDetailsScreen extends StatelessWidget {
  const ChangeDetailsScreen({super.key});

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final newPasswordController = TextEditingController();
    final currentPasswordController = TextEditingController();

    InputDecoration customDecoration(String label) => InputDecoration(
      labelText: label,
      focusedBorder: formBorder,
      labelStyle: const TextStyle(color: Colors.black),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Details', style: appBarTitleTextStyle),
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      backgroundColor: AppColors.bodyBackgroundColor,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: customDecoration('New Username'),
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: customDecoration('New E-mail'),
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                decoration: customDecoration('New Password'),
                obscureText: true,
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: currentPasswordController,
                decoration: customDecoration('Current Password'),
                obscureText: true,
                cursorColor: Colors.black,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newUsername = usernameController.text.trim();
                  final newEmail = emailController.text.trim();
                  final newPassword = newPasswordController.text;
                  final currentPassword = currentPasswordController.text;

                  if (newUsername.isEmpty &&
                      newEmail.isEmpty &&
                      newPassword.isEmpty) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("No Changes Made"),
                            content: const Text(
                              "You haven't updated any fields.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK", style: TextStyle(color: Colors.black),),
                              ),
                            ],
                          ),
                    );
                    return;
                  }

                  if (newPassword.isNotEmpty && currentPassword.isEmpty) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.white,

                            title: const Text("Missing Current Password"),
                            content: const Text(
                              "To change your password, please enter your current password.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK", style: TextStyle(color: Colors.black),),
                              ),
                            ],
                          ),
                    );
                    return;
                  }

                  if (newEmail.isNotEmpty && !isValidEmail(newEmail)) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Invalid Email"),
                            content: const Text(
                              "Please enter a valid email address.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK", style: TextStyle(color: Colors.black),),
                              ),
                            ],
                          ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.black,
                      content: Text(
                        'Details updated!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: buttonStyle,
                child: const Text('Submit Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
