import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:flutter/material.dart';
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
                Text(
                  'PC Goblin',
                  style: logoTextStyle2,
                ),
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
                  onPressed: () => Navigator.pushReplacementNamed(context, '/builder'),
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
  const SignInScreen({super.key});

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
                  decoration:  InputDecoration(labelText: 'Email',
                  floatingLabelStyle : TextStyle(color: Colors.black),
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
                  decoration:  InputDecoration(labelText: 'Password',
                  floatingLabelStyle : TextStyle(color: Colors.black),
                  focusedBorder: formBorder
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
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                     Navigator.pushNamedAndRemoveUntil(context, '/builder', (route) => false,);
                    }
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.appBarBackgroundColor,
      ),
      body: Container(
        color: AppColors.bodyBackgroundColor,
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                 keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  cursorColor: Colors.black,
                  decoration:  InputDecoration(labelText: 'Email',
                  floatingLabelStyle : TextStyle(color: Colors.black),
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
                const SizedBox(height: 24),
                ElevatedButton(
                  style: loginButtonStyle,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/profileSetup');
                    }
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),

      ),
    );
  }
}

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
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
                ),
                const SizedBox(height: 16),
                _buildStyledTextFormField(
                  label: 'Your Surname',
                  controller: surnameController,
                ),
                const SizedBox(height: 16),
                _buildStyledTextFormField(
                  label: 'Password',
                  controller: passwordController,
                  obscure: true,
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
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pushNamedAndRemoveUntil(context, '/builder', (route) => false,);

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
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Cannot leave $label empty!';
            }
            return null;
          },
      decoration:  InputDecoration(labelText: label,
                  floatingLabelStyle : TextStyle(color: Colors.black),
                  focusedBorder: formBorder,
                  ),       
    );
  }
}