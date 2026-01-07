import 'package:ezycart/features/authentication/screens/login/login.dart';
import 'package:ezycart/features/authentication/screens/onBoarding/onboarding.dart';
import 'package:ezycart/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();

  /// Firebase auth instance.
  /// We access it lazily to allow clearer error messages if Firebase isn't initialized yet.
  FirebaseAuth get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      throw 'Firebase is not initialized. Ensure Firebase.initializeApp() was called.';
    }
  }

  /// Get Authenticated User Data
  User? get authUser => FirebaseAuth.instance.currentUser;

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
      // Ensure Firebase initialized
      if (Firebase.apps.isEmpty) {
        throw 'Firebase is not initialized. Please check your configuration.';
      }

      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, st) {
      // Log for debugging
      debugPrint(
        'loginWithEmailAndPassword FirebaseAuthException: ${e.code} - ${e.message}',
      );
      debugPrintStack(stackTrace: st);
      // Preserve Firebase error messages but provide a default
      throw e.message ??
          'Authentication failed. Please check your credentials.';
    } catch (e, st) {
      debugPrint('loginWithEmailAndPassword error: $e');
      debugPrintStack(stackTrace: st);
      // Pass string errors through, otherwise provide fallback
      if (e is String) rethrow;
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
  Future<UserCredential?> signInWithGoogle({GoogleSignIn? googleSignIn}) async {
    try {
      // Ensure Firebase initialized
      if (Firebase.apps.isEmpty) {
        throw 'Firebase is not initialized. Please check your configuration.';
      }

      // Allow injection for testing; default to normal GoogleSignIn.
      // Only provide clientId when explicitly set (helps avoid platform issues)
      final clientId = dotenv.env['GOOGLE_CLIENT_ID'];
      final signIn =
          googleSignIn ??
          (clientId != null && clientId.isNotEmpty
              ? GoogleSignIn(clientId: clientId)
              : GoogleSignIn());

      // If a client ID is required on web and missing, warn early
      if ((clientId ?? '').isEmpty && kIsWeb) {
        throw 'Google Client ID is missing. Add GOOGLE_CLIENT_ID to your .env.';
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await signIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        throw 'Google sign-in was cancelled.';
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Ensure tokens are present
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw 'Google authentication did not return any tokens. Try again or check your Google configuration.';
      }

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e, st) {
      debugPrint(
        'signInWithGoogle FirebaseAuthException: ${e.code} - ${e.message}',
      );
      debugPrintStack(stackTrace: st);
      throw e.message ?? 'Google authentication failed.';
    } catch (e, st) {
      debugPrint('Google Sign-In Error: $e');
      debugPrintStack(stackTrace: st);
      if (e is String) rethrow;
      throw 'Something went wrong with Google sign-in.';
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
