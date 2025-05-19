import 'package:findmepcparts/services/auth_provider.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    final AuthService _auth = Provider.of<AuthService>(context);
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
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
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),

                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    String user_email = emailController.text;
                    FirebaseAuth.instance.sendPasswordResetEmail(email: user_email);
                    showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: Colors.white,

                              title: const Text("Email sent!"),
                              content: Text("Sent password reset link to $user_email"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false),
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
                child: const Text('Reset password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}