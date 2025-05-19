import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmepcparts/services/auth_provider.dart'; // Assuming AuthService might be useful, or for consistency
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../util/text_styles.dart';
import '../../util/paddings.dart';
import '../../util/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Loading...';
  String _surname = '';
  String _username = 'Loading...';
  String _email = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _email = currentUser.email ?? 'Not available';
      });
      try {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userData.exists) {
          setState(() {
            _name = userData.get('name') ?? 'N/A';
            _surname = userData.get('surname') ?? '';
            _username = userData.get('username') ?? 'N/A';
            _isLoading = false;
          });
        } else {
          setState(() {
            _name = 'User data not found';
            _username = 'N/A';
            _isLoading = false;
          });
        }
      } catch (e) {
        print("Error loading user data: $e");
        setState(() {
          _name = 'Error loading data';
          _username = 'Error';
          _isLoading = false;
        });
      }
    } else {
      // Should ideally not happen if entry to this screen is guarded
      setState(() {
        _name = 'Not logged in';
        _email = '';
        _username = '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    String displayName = _surname.isNotEmpty ? '$_name $_surname' : _name;

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: AppPaddings.screen,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'), // Placeholder
              ),
              const SizedBox(height: 20),
              Text(displayName, style: settingsBody.copyWith(fontSize: 20, fontWeight: FontWeight.bold)), // Display name
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          _profileItem(Icons.person_outline, 'Username', _username, textColor),
          _profileItem(Icons.email_outlined, 'E-mail', _email, textColor),
          _profileItem(Icons.lock_outline, 'Password', '••••••••', textColor), // Static password display
          const Divider(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (FirebaseAuth.instance.currentUser != null) {
                  await Navigator.pushNamed(context, '/changeDetails');
                  if (mounted) {
                    _loadUserData();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to change your details.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Change details', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileItem(IconData icon, String label, String value, Color color) {
    return ListTile(
      leading: Icon(icon, size: 28, color: color),
      title: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      subtitle: Text(value, style: TextStyle(fontSize: 18, color: color.withOpacity(0.8))),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    );
  }
}