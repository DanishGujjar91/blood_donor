import 'package:blood_donor/constants/color_constant.dart';
import 'package:blood_donor/helper_widget/custom_appbar.dart';
import 'package:blood_donor/helper_widget/custom_text_form_field.dart';
import 'package:blood_donor/helper_widget/helper_service.dart/custom_loader.dart';
import 'package:blood_donor/helper_widget/helper_service.dart/custom_snackbar.dart';
import 'package:blood_donor/screens/dashboard/auth/logout_screen.dart';
import 'package:blood_donor/screens/dashboard/auth/signup_screen.dart';
import 'package:blood_donor/screens/dashboard/dashboard_screen.dart';
import 'package:blood_donor/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FocusNode _userFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardScreen()),
              ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(160.0),
          child: CustomAppBar(
            icon: Icons.bloodtype,
            iconSize: 110,
            title: 'Blood-Bank',
          )),
      bottomNavigationBar: Container(
        height: 20,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 130),
        child: Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                    text: "Already have an account?",
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 15,
                    ),
                    children: [
                      const WidgetSpan(
                          child: SizedBox(
                        width: 5,
                      )),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()),
                            );
                          },
                        text: 'Create',
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: primaryColor),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 85, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Welcome to login',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Plase sign in to continue',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomTextFormField(
                        controller: email,
                        autoFocus: false,
                        hinttext: 'Email',
                        labeltext: 'Email',
                        prefixicon: const Icon(
                          Icons.email,
                          color: primaryColor,
                        ),
                      ),
                      CustomTextFormField(
                        controller: password,
                        keyboardtype: TextInputType.text,
                        obscuretext: true,
                        autoFocus: false,
                        hinttext: 'Password',
                        labeltext: 'Password',
                        prefixicon: const Icon(
                          Icons.password,
                          color: primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_validateLogin()) {
                                signUserIn();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  // side: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  _validateLogin() {
    if (email.text.isEmpty) {
      CustomSnackBar.failedSnackBar(
          context: context, message: "Enter Valid UserName");
      _userFocus.requestFocus();
      return false;
    } else if (password.text.isEmpty) {
      CustomSnackBar.failedSnackBar(
          context: context, message: "Password must be more then 6 character");
      _passwordFocus.requestFocus();
      return false;
    } else {
      return true;
    }
  }
}
