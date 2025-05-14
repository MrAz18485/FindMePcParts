import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:findmepcparts/services/auth_gate.dart';

import 'package:email_validator/email_validator.dart';

class LoginChoiceScreen extends StatelessWidget {
  const LoginChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 90),
                Text('PC Goblin', style: logoTextStyle2),
                const SizedBox(height: 40),
                ClipOval(
                  child: Image.asset(
                    "assets/goblin.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signin'),
                  style: loginButtonStyle,
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  style: loginButtonStyle,
                  child: const Text('Create an account'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => Navigator.pushReplacementNamed(context, '/builder'),
                  style: guestButtonStyle,
                  child: const Text('Continue as guest'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      backgroundColor: AppColors.bodyBackgroundColor,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: AppColors.bodyBackgroundColor,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Email',
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  focusedBorder: formBorder,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot leave email empty!";
                  }
                  if (!EmailValidator.validate(value)) {
                    return "Not a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Password',
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  focusedBorder: formBorder,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),

                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // print(emailController.text);
                    dynamic result = await _auth.signInEmailPass(
                      emailController.text,
                      passwordController.text,
                    );
                    if (result != null) {
                      print("Failed to login: $result");
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: Colors.white,

                              title: const Text("Error"),
                              content: Text("$result"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "OK",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                      );
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/builder',
                        (route) => false,
                      ); // successful login
                    }
                  }
                },
                child: const Text('Continue'),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),

                onPressed: () {
                  
                },
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSetupScreen extends StatelessWidget {
  ProfileSetupScreen({super.key});
  final AuthService _auth = AuthService();

  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final usernamecontroller = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: AppBar(
        title: const Text("Let's Finish Your Profile"),
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      body: Container(
        color: AppColors.bodyBackgroundColor,
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildStyledTextFormField(
                label: 'Your Name',
                controller: nameController,
                validator: null
              ),

              const SizedBox(height: 16),

              _buildStyledTextFormField(
                label: 'Your Surname',
                controller: surnameController,
                validator: null
              ),

              const SizedBox(height: 16),

              _buildStyledTextFormField(
                label: 'Username',
                controller: usernamecontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot leave username empty!";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildStyledTextFormField(
                label: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot leave email empty!";
                  }
                  if (!EmailValidator.validate(value)) {
                    return "Not a valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildStyledTextFormField(
                label: 'Password',
                controller: passwordController,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                      return "Cannot leave Password empty!";
                  }
                  else if (value.length < 6)
                  {
                    return "Password length cannot be less than 6!";
                  }
                  return null;
                }
              ),

              const SizedBox(height: 16),

              _buildStyledTextFormField(
                label: 'Confirm Password',
                controller: confirmPasswordController,
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot leave Confirm Password empty!";
                  }
                  if (value != passwordController.text) {
                    return "Passwords do not match!";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackgroundColor,
                  foregroundColor: AppColors.buttonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerEmailPass(
                      emailController.text,
                      passwordController.text,
                      usernamecontroller.text,
                      nameController.text,
                      surnameController.text,
                    );
                    if (result == null) {
                      print("Registered user!");
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/builder',
                        (route) => false,
                      ); // successful login
                    }
                    else
                    {
                      showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text("Error"),
                            content: Text("$result"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                    );
                    }
                  } else {
                    print("Invalid form!");
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.white,

                            title: const Text("Error"),
                            content: Text("At least one required field is empty/invalid."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                    );
                  }
                },
                child: const Text('Finish'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextFormField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(color: Colors.black),
        focusedBorder: formBorder,
      ),
      validator: validator,
    );
  }
}

