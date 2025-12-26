import 'package:ezycart/features/authentication/screens/login/login.dart';
import 'package:ezycart/features/authentication/screens/onBoarding/onboarding.dart';
import 'package:ezycart/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    // Remove the native splash screen if it's still there (handled by main.dart usually now)
    // FlutterNativeSplash.remove();
    // screenRedirect(); // Removed from here
  }

  // Called manually from SplashScreen
  void screenRedirect() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // If user is logged in, go to Home
        Get.offAll(() => const NavigationMenu());
      } else {
        // Local Storage
        deviceStorage.writeIfNull('IsFirstTime', true);

        // Check if it's the first time launching the app
        deviceStorage.read('IsFirstTime') != true
            ? Get.offAll(
                () => const LoginScreen(),
              ) // Redirect to Login if not first time
            : Get.offAll(
                () => const OnBoardingScreen(),
              ); // Redirect to OnBoarding if first time
      }
    } catch (e) {
      // Handle potential errors (e.g., Firebase initialization issues on web)
      debugPrint('Error in screenRedirect: $e');
      // Fallback to LoginScreen or OnBoarding if something goes wrong
      Get.offAll(() => const LoginScreen());
    }
  }

  /* ---------------------------- Email & Password Sign In --------------------------------- */

  /// [EmailAuthentication] - Login
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message!; // Simplified error handling
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailAuthentication] - Register
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailVerification] - MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Send password reset email to the provided [email]
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [GoogleAuthentication] - GOOGLE
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      // Client ID is required for Web. It is ignored on Android/iOS.
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: dotenv.env['GOOGLE_CLIENT_ID'],
      ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  /// [LogoutUser] - Valid for any authentication.
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Show a confirmation dialog before logging out. Use this to ensure
  /// a consistent logout confirmation across the app.
  void confirmAndLogout({
    String title = 'Logout',
    String middleText = 'Are you sure you want to logout?',
    String textCancel = 'Cancel',
    String textConfirm = 'Logout',
  }) {
    Get.defaultDialog(
      title: title,
      middleText: middleText,
      textCancel: textCancel,
      textConfirm: textConfirm,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        try {
          await logout();
        } catch (e) {
          // Show brief error and remain on screen
          Get.snackbar('Error', e.toString());
        }
      },
    );
  }
}
