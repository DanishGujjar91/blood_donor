import 'dart:io';
import 'package:blood_donor/constants/color_constant.dart';
import 'package:blood_donor/helper_widget/custom_appbar.dart';
import 'package:blood_donor/helper_widget/custom_text_form_field.dart';
import 'package:blood_donor/models/user_model.dart';
import 'package:blood_donor/screens/dashboard/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  String? downloadUrl;
  String? profilePic;

  final _formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (FirebaseAuth.instance.currentUser!.displayName == null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('please complete profile firsty')));
    //   } else {
    //     FirebaseFirestore.instance
    //         .collection('Users')
    //         .doc(FirebaseAuth.instance.currentUser!.uid)
    //         .get()
    //         .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
    //       name.text = snapshot.data()!['name'];
    //       email.text = snapshot.data()!['email'];
    //       password.text = snapshot.data()!['password'];
    //       confirmPassword.text = snapshot.data()!['confirmPassword'];
    //       phone.text = snapshot.data()!['phoneNo'];
    //       profilePic = snapshot.data()!['image'];
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(85.0),
          child: CustomAppBar(
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
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                        text: 'Login',
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
            children: [
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                final XFile? pickImage = await ImagePicker()
                                    .pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50);
                                if (pickImage != null) {
                                  setState(() {
                                    profilePic = pickImage.path;
                                  });
                                }
                              },
                              child: Container(
                                child: profilePic == null
                                    ? CircleAvatar(
                                        radius: 60,
                                        backgroundColor: lightGreyColor,
                                        child: Image.asset(
                                            'assets/images/profile.png',
                                            width: 115,
                                            height: 115),
                                      )
                                    : CircleAvatar(
                                        radius: 60,
                                        backgroundImage:
                                            FileImage(File(profilePic!)),
                                      ),
                              ),
                            ),
                            Column(
                              children: [
                                CustomTextFormField(
                                  controller: name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    if (!RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,29}$")
                                        .hasMatch(value)) {
                                      return "Please enter a valid name";
                                    }
                                    return null;
                                  },
                                  keyboardtype: TextInputType.name,
                                  autoFocus: false,
                                  hinttext: 'Name',
                                  labeltext: 'Name',
                                  prefixicon: const Icon(
                                    Icons.person,
                                    color: primaryColor,
                                  ),
                                ),
                                CustomTextFormField(
                                  controller: email,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return "Please enter a valid email address";
                                    }
                                    return null;
                                  },
                                  keyboardtype: TextInputType.emailAddress,
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
                                  validator: (value) {
                                    RegExp regex = RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                    if (value!.isEmpty) {
                                      return 'Please enter password';
                                    } else if (value.length < 6) {
                                      return 'Password too short';
                                    } else {
                                      if (!regex.hasMatch(value)) {
                                        return 'Enter valid password';
                                      } else {
                                        return null;
                                      }
                                    }
                                  },
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
                                CustomTextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Plase enter re-password';
                                    }
                                    if (password.text != confirmPassword.text) {
                                      return 'Password do not match';
                                    }
                                    return null;
                                  },
                                  controller: confirmPassword,
                                  keyboardtype: TextInputType.text,
                                  obscuretext: true,
                                  autoFocus: false,
                                  hinttext: 'ConfirmPassword',
                                  labeltext: 'Confirm Password',
                                  prefixicon: const Icon(
                                    Icons.password,
                                    color: primaryColor,
                                  ),
                                ),
                                CustomTextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Plase enter re-password';
                                    }
                                    if (password.text != confirmPassword.text) {
                                      return 'Password do not match';
                                    }
                                    return null;
                                  },
                                  controller: confirmPassword,
                                  keyboardtype: TextInputType.text,
                                  obscuretext: true,
                                  autoFocus: false,
                                  hinttext: 'Blood Group',
                                  labeltext: 'Blood Group',
                                  prefixicon: const Icon(
                                    Icons.password,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  child: IntlPhoneField(
                                    controller: phone,
                                    decoration: InputDecoration(
                                      focusColor: primaryColor,
                                      hoverColor: primaryColor,
                                      hintText: 'Phone Number',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            const BorderSide(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      counter: const Offstage(),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                    onChanged: (phone) {
                                      print(phone.completeNumber);
                                    },
                                    onCountryChanged: (country) {
                                      print(
                                          'Country changed to: ${country.name}');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    createUserWithEmailAndPassword();
                                    const snackBar = SnackBar(
                                      content: Text(
                                          'Your account is created successfully!'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
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
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> uploadImage(File filepath) async {
    try {
      String fileName =
          '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().second}';

      final storageRef =
          FirebaseStorage.instance.ref().child('users/$fileName');
      final UploadTask uploadTask = storageRef.putFile(filepath);
      await uploadTask.whenComplete(() async {
        downloadUrl = await storageRef.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  createUserWithEmailAndPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      uploadImage(File(profilePic!)).whenComplete(() async {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .add(UserModel(
                id: userCredential.user!.uid,
                name: name.text.trim(),
                email: email.text.trim(),
                password: password.text.trim(),
                confirmPassword: confirmPassword.text.trim(),
                phoneNo: phone.text.trim(),
                image: downloadUrl,
              ).toJson())
              .then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  ));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    Navigator.pop(context);
  }
}
