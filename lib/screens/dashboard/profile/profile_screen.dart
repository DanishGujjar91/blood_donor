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
  bool isSaving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
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
    //       name.text = snapshot['name'];
    //       email.text = snapshot['email'];
    //       password.text = snapshot['password'];
    //       confirmPassword.text = snapshot['confirmPassword'];
    //       phone.text = snapshot['phoneNo'];
    //     });
    //   }
    // });
    // Future getDatabaseData() async {
    //   await FirebaseFirestore.instance
    //       .collection('Users')
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .get()
    //       .then((value) async {
    //     if (value.exists) {
    //       setState(() {
    //         name = value.data()!['name'];
    //         email = value.data()!['email'];
    //         password = value.data()!['password'];
    //         confirmPassword = value.data()!['confirmPassword'];
    //         phone = value.data()!['phoneNo'];
    //       });
    //       print(value.exists);
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
                    'Update Your profile!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
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
                          backgroundColor: primaryColor,
                          child: Image.asset('assets/images/profile.png',
                              width: 80, height: 80),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(File(profilePic!)),
                        ),
                ),
              ),
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
                  print('Country changed to: ' + country.name);
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
                    'Signup',
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

  update() {
    uploadImage(File(profilePic!), 'profile').whenComplete(() {
      FirebaseFirestore.instance
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
}
