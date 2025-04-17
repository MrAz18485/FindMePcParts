import 'package:flutter/material.dart';

class ChangeDetailsScreen extends StatelessWidget {
  const ChangeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final newPasswordController = TextEditingController();
    final currentPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Change Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'New Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'New E-mail'),
            ),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Details updated!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Submit Changes'),
            )
          ],
        ),
      ),
    );
  }
}
