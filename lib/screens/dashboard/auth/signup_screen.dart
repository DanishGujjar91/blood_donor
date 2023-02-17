import 'dart:io';
import 'package:blood_donor/constants/color_constant.dart';
import 'package:blood_donor/helper_widget/custom_text_form_field.dart';
import 'package:blood_donor/models/user_model.dart';
import 'package:blood_donor/screens/dashboard/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (FirebaseAuth.instance.currentUser!.displayName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('please complete profile firsty')));
      } else {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          name.text = snapshot.data()!['name'];
          email.text = snapshot.data()!['email'];
          password.text = snapshot.data()!['password'];
          confirmPassword.text = snapshot.data()!['confirmPassword'];
          phone.text = snapshot.data()!['phoneNo'];
          profilePic = snapshot.data()!['image'];
          print(name.text);
          print(email.text);
          print(password.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 25, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        'Create Your Account !',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        final XFile? pickImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 50);
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
                                backgroundColor: primaryColor,
                                child: Image.asset('assets/images/profile.png',
                                    fit: BoxFit.fill, width: 130, height: 130),
                              )
                            : profilePic!.contains('http')
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(profilePic!))
                                : CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        FileImage(File(profilePic!)),
                                  ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
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
                SizedBox(
                  height: 70,
                  child: IntlPhoneField(
                    controller: phone,
                    decoration: InputDecoration(
                      focusColor: primaryColor,
                      hoverColor: primaryColor,
                      hintText: 'Phone Number',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      counter: const Offstage(),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 6.0, top: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    onCountryChanged: (country) {
                      // print('Country changed to: ' + country.name);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          const snackBar = SnackBar(
                            content: Text('select proifle pic!'),
                          );
                          profilePic == null
                              ? ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar)
                              : createUserWithEmailAndPassword();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            // side: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      child: Text(name.text.isEmpty ? 'Signup' : 'Update'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    uploadImage(File(profilePic!)).whenComplete(() async {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        )
            .then((value) async {
          await firebaseFirestore
              .collection('Users')
              .add(UserMode(
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
    });
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    Navigator.pop(context);
  }

  // void create() async {
  //   await Auth().createUser(
  //       UserMode(
  //           name: name.text.trim(),
  //           email: email.text.trim(),
  //           password: password.text.trim(),
  //           confirmPassword: confirmPassword.text.trim(),
  //           phoneNo: phone.text.trim()),
  //       context);
  // }
}
