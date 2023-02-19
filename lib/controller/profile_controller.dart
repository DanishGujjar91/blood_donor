// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';

// class ProfileController extends GetxController {
//   final firetore = FirebaseFirestore.instance;

//   Map userProfileData = {'name': '', 'email': ''};
  
//   void onReady() {
//     super.onReady();
    
//     getUserProfileData();
//   }
  
//   Future<void> getUserProfileData() async {
//     // print("user id ${authController.userId}");
//     try {
//       var response = await firetore
//           .collection('Users')
//           .where('user_Id', isEqualTo: authController.userId)
//           .get();
//       // response.docs.forEach((result) {
//       //   print(result.data());
//       // });
//       if (response.docs.length > 0) {
//         userProfileData['userName'] = response.docs[0]['user_name'];
//         userProfileData['joinDate'] = response.docs[0]['joinDate'];
//       }
//       print(userProfileData);
//     } on FirebaseException catch (e) {
//       print(e);
//     } catch (error) {
//       print(error);
//     }
//   }

// }



