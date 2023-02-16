// import 'package:blood_donor/repository/auth_repo/exceptions/signup_email_password_failure.dart';
// import 'package:blood_donor/screens/auth_screen/dashboard/dashboard_screen.dart';
// import 'package:blood_donor/screens/auth_screen/welcome_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class AuthRepo extends GetxController {
//   static AuthRepo get instance => Get.put(AuthRepo());

//   //variable
//   final _auth = FirebaseAuth.instance;

//   late final Rx<User?> firebaseUser;

//   @override
//   void onReady() {
//     Future.delayed(const Duration(seconds: 6));
//     firebaseUser = Rx<User?>(_auth.currentUser);
//     firebaseUser.bindStream(_auth.userChanges());

//     ever(firebaseUser, _setInitialScreen);
//   }

//   _setInitialScreen(User? user) {
//     user == null
//         ? Get.offAll(() => const WelcomeScreen())
//         : Get.offAll(() => const DashboardScreen());
//   }

//   Future<void> createUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       firebaseUser.value != null
//           ? Get.offAll(() => const DashboardScreen())
//           : Get.to(() => const WelcomeScreen());
//     } on FirebaseAuthException catch (e) {
//       final ex = SignupWithEmailAndPasswordFailure.code(e.code);
//       print('Firebase Auth Exception - ${ex.message}');
//     } catch (_) {
//       const ex = SignupWithEmailAndPasswordFailure();
//       print('Exception - ${ex.message}');
//       throw ex;
//     }
//   }

//   Future<void> loginUserWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//     } on FirebaseAuthException catch (e) {
//       final ex = SigninWithEmailAndPasswordFailure.code(e.code);
//       print('Firebase Auth Exception - ${ex.message}');
//     } catch (_) {
//       const ex = SigninWithEmailAndPasswordFailure();
//       print('Exception - ${ex.message}');
//       throw ex;
//     }

//     Future<void> signOut() async {
//       await _auth.signOut();
//     }
//   }
// }
