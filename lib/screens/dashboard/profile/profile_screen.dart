import 'dart:io';

import 'package:blood_donor/constants/color_constant.dart';
import 'package:blood_donor/helper_widget/custom_text_form_field.dart';
import 'package:blood_donor/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.userMode});
  final UserMode? userMode;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('Users');

  String? profilePic;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (FirebaseAuth.instance.currentUser!.displayName == null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('please complete profile firsty')));
    //   } else {
    //     FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(FirebaseAuth.instance.currentUser!.uid)
    //         .get()
    //         .then((DocumentSnapshot documentSnapshot) {
    //       if (documentSnapshot.exists) {
    //         print('Document exists on the database');
    //       }
    //     });
    //   }
    // });
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                final XFile? pickImage = await ImagePicker()
                    .pickImage(source: ImageSource.gallery, imageQuality: 50);
                if (pickImage != null) {
                  setState(() {
                    profilePic = pickImage.path;
                  });
                }
              },
              child: Center(
                child: Container(
                  child: profilePic == null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundColor: lightGreyColor,
                          child: Image.asset('assets/images/profile.png',
                              width: 115, height: 115),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(File(profilePic!)),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                if (!RegExp(r"^[A-Za-z][A-Za-z0-9_]{7,29}$").hasMatch(value)) {
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
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
                onCountryChanged: (country) {
                  print('Country changed to: ${country.name}');
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
                      update();
                      const snackBar = SnackBar(
                        content: Text('Your profile is updated successfully!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        // side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? downloadUrl;
  Future<String?> uploadImage(File filepath, String? reference) async {
    try {
      final finalName =
          '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().second}';

      final Reference fbStorage =
          FirebaseStorage.instance.ref(reference).child(finalName);
      final UploadTask uploadTask = fbStorage.putFile(filepath);
      await uploadTask.whenComplete(() async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future update() async {
    await uploadImage(File(profilePic!), 'profile').whenComplete(() async {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(UserMode(
                  image: downloadUrl,
                  name: name.text,
                  email: email.text,
                  password: password.text,
                  confirmPassword: confirmPassword.text,
                  phoneNo: phone.text)
              .toJson())
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(name.text);
      });
    });
  }

  fetch() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
