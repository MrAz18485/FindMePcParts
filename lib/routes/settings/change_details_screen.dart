import 'package:findmepcparts/services/auth_gate.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../util/text_styles.dart';

class ChangeDetailsScreen extends StatefulWidget {
  const ChangeDetailsScreen({super.key});

  @override
  State<ChangeDetailsScreen> createState() => _ChangeDetailsScreenState();
}

class _ChangeDetailsScreenState extends State<ChangeDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();

  bool _isLoadingSubmit = false;
  bool _isFetchingInitialDetails = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserDetails();
  }

  Future<void> _loadCurrentUserDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _emailController.text = currentUser.email ?? '';
      try {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userData.exists) {
          _usernameController.text = userData.get('username') ?? '';
        } else {
          _usernameController.text = '';
        }
      } catch (e) {
        print("Error loading current username: $e");
        _usernameController.text = '';
      }
    } else {
      _usernameController.text = '';
      _emailController.text = '';
    }
    setState(() {
      _isFetchingInitialDetails = false;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  void _showFeedbackDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.black,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _submitChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoadingSubmit = true;
    });

    final newUsername = _usernameController.text.trim();
    final newEmail = _emailController.text.trim();
    final newPassword = _newPasswordController.text;
    final currentPassword = _currentPasswordController.text;

    List<String> successMessages = [];
    List<String> errorMessages = [];

    if (newUsername.isEmpty && newEmail.isEmpty && newPassword.isEmpty) {
      _showFeedbackDialog("No Changes Made", "You haven't updated any fields that initiated a change.");
      setState(() {
        _isLoadingSubmit = false;
      });
      return;
    }

    // Update Username
    if (newUsername.isNotEmpty) {
      final result = await _authService.updateUsername(newUsername);
      if (result == null) {
        successMessages.add("Username updated.");
      } else {
        errorMessages.add("Username update failed: $result");
      }
    }

    // Update Email
    if (newEmail.isNotEmpty) {
      if (!_isValidEmail(newEmail)) {
        errorMessages.add("Invalid email format.");
      } else {
        final result = await _authService.updateUserEmail(newEmail);
        if (result == null) {
          successMessages.add("Email updated.");
        } else {
          errorMessages.add("Email update failed: $result");
        }
      }
    }

    // Update Password
    if (newPassword.isNotEmpty) {
      if (currentPassword.isEmpty) {
        errorMessages.add("Current password is required to change your password.");
      } else {
        final result = await _authService.updateUserPassword(currentPassword, newPassword);
        if (result == null) {
          successMessages.add("Password updated.");
        } else {
          errorMessages.add("Password update failed: $result");
        }
      }
    }

    setState(() {
      _isLoadingSubmit = false;
    });

    if (errorMessages.isNotEmpty) {
      _showFeedbackDialog("Update Result", errorMessages.join("\n"));
    }

    if (successMessages.isNotEmpty) {
      _showSnackBar(successMessages.join(" ") + (errorMessages.isNotEmpty ? " Some updates failed." : " All changes successful!"));
      if (successMessages.any((msg) => msg.contains("Username")) && !errorMessages.any((err) => err.contains("Username"))) _usernameController.text = newUsername;
      if (successMessages.any((msg) => msg.contains("Email")) && !errorMessages.any((err) => err.contains("Email"))) _emailController.text = newEmail;

      _newPasswordController.clear();
      _currentPasswordController.clear();

      if (errorMessages.isEmpty && successMessages.isNotEmpty) {
      }
    } else if (successMessages.isEmpty && errorMessages.isEmpty && (newUsername.isNotEmpty || newEmail.isNotEmpty || newPassword.isNotEmpty)) {
      _showSnackBar("No changes applied. Ensure new values are different or fields are filled correctly.");
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isFetchingInitialDetails
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: customDecoration('Username'),
                  cursorColor: Colors.black,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: customDecoration('E-mail'),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !_isValidEmail(value)) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: customDecoration('New Password (leave blank if no change)'),
                  obscureText: true,
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password must be at least 6 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _currentPasswordController,
                  decoration: customDecoration('Current Password (required for password change)'),
                  obscureText: true,
                  cursorColor: Colors.black,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoadingSubmit ? null : _submitChanges,
                  style: buttonStyle,
                  child: _isLoadingSubmit
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                      : const Text('Submit Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}