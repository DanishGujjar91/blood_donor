import 'dart:async';
import 'package:blood_donor/models/user_model.dart';
import 'package:blood_donor/screens/dashboard/auth/login_screen.dart';
import 'package:blood_donor/screens/dashboard/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  createUser(UserMode user, BuildContext context) async {
    const snackBar = SnackBar(
      content: Text('Your account is created successfully!'),
    );
    const snackBarError = SnackBar(
      content: Text('Someting went wrong. Try again'),
    );
    await firestore
        .collection('Users')
        .add(user.toJson())
        .whenComplete(
            () => ScaffoldMessenger.of(context).showSnackBar(snackBar))
        .catchError((error, stackTree) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarError);
      print(error.toString());
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void isLogin(BuildContext context) {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      Timer(
        const Duration(seconds: 3),
        (() => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ))),
      );
    } else {
      Timer(
        const Duration(seconds: 1),
        (() => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ))),
      );
    }
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const DashboardScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
