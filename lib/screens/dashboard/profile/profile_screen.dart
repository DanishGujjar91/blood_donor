import 'dart:io';
import 'package:blood_donor/constants/color_constant.dart';
import 'package:blood_donor/helper_widget/custom_text_form_field.dart';
import 'package:blood_donor/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.userMode});
  final UserModel? userMode;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var nameC = TextEditingController();
  var emailC = TextEditingController();
  var phoneC = TextEditingController();
  var passwordC = TextEditingController();
  var confirmPasswordC = TextEditingController();

  String? profilePic;
  String? downloadUrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                              backgroundColor: lightGreyColor,
                              child: Image.asset('assets/images/profile.png',
                                  width: 115, height: 115),
                            )
                          : profilePic!.contains('http')
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(profilePic!))
                              : CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(File(profilePic!)),
                                ),
                    ),
                  ),
                  Column(
                    children: [
                      CustomTextFormField(
                        controller: nameC,
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
                        controller: emailC,
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
                        controller: passwordC,
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
                          if (passwordC.text != confirmPasswordC.text) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                        controller: confirmPasswordC,
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
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: IntlPhoneField(
                          controller: phoneC,
                          decoration: InputDecoration(
                            focusColor: primaryColor,
                            hoverColor: primaryColor,
                            hintText: 'Phone Number',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            counter: const Offstage(),
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
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          update();
                          const snackBar = SnackBar(
                            content:
                                Text('Your profile is updated successfully!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                      child: const Text(
                        'Update',
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
    );
  }

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
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(UserModel(
                  image: downloadUrl,
                  name: nameC.text,
                  email: emailC.text,
                  password: passwordC.text,
                  confirmPassword: confirmPasswordC.text,
                  phoneNo: phoneC.text)
              .toJson())
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
      });
    });
  }

  Future<UserModel> getHomeData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    try {
      var querySnapshot = await collection.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();

        setState(() {
          UserModel(
            name: data['name'],
            email: data['email'],
            image: data['image'],
          );
        });
      }
    } catch (e) {
      print('Document does not exist on the database: $e');
    }
    return UserModel();
  }

  Future getProfileData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    try {
      var querySnapshot = await collection.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();

        setState(() {
          nameC = TextEditingController(text: data['name']);
          emailC = TextEditingController(text: data['email']);
          passwordC = TextEditingController(text: data['password']);
          confirmPasswordC =
              TextEditingController(text: data['confirmPassword']);
          phoneC = TextEditingController(text: data['phoneNo']);
          profilePic = data['image'];
        }); // <-- Retrieving the value.
      }
    } catch (e) {
      print('Document does not exist on the database: $e');
    }
    return collection;
  }

  // Future<String?> getImage(String imageName) async {
  //   Reference firebaseStorage = FirebaseStorage.instance.ref();
  //   if (imageName == null) {
  //     return null;
  //   }
  //   try {
  //     var urlRef = firebaseStorage
  //         .child("users")
  //         .child('${imageName.toLowerCase()}.png');
  //     var imgUrl = await urlRef.getDownloadURL();
  //     return imgUrl;
  //   } catch (e) {}
  // }
}
