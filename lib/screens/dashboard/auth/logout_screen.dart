import 'package:blood_donor/screens/dashboard/auth/login_screen.dart';
import 'package:blood_donor/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  String? errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    logout().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    });
                  },
                  child: const Text('Logout')))
        ],
      ),
    );
  }

  Future<void> logout() async {
    try {
      await Auth().signOut();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
  }
}
