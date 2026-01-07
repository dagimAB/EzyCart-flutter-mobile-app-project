import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/data/repositories/user/user_repository.dart';
import 'package:ezycart/features/authentication/screens/signup/verify_email.dart';
import 'package:ezycart/features/personalization/models/user_model.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:ezycart/utils/errors/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final privacyPolicy =
      true.obs; // Default to true to reduce friction, or false to force check

  // -- Loading
  final isLoading = false.obs;

  /// -- Signup
  Future<void> signup() async {
    try {
      // 1. Form Validation
      if (!signupFormKey.currentState!.validate()) {
        ELoaders.warningSnackBar(
          title: 'Validation Error',
          message: 'Please fill all fields correctly.',
        );
        return;
      }

      // 2. Privacy Policy Check
      if (!privacyPolicy.value) {
        ELoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'You must accept the privacy policy and terms of use to create an account.',
        );
        return;
      }

      // 3. Start Loading
      isLoading.value = true;

      // 4. Register user
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
            email.text.trim(),
            password.text.trim(),
          );

      // 5. Save User Data
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // 6. Success
      ELoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your account has been created! Verify email to continue.',
      );

      // 7. Move to Verify Email
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      debugPrint('Signup error: $e');
      ELoaders.errorSnackBar(title: 'Signup Failed', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// -- Google SignIn
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      isLoading.value = true;

      // Google Authentication
      final userCredentials = await AuthenticationRepository.instance
          .signInWithGoogle();

      // Save User Record
      if (userCredentials != null) {
        final userRepository = Get.put(UserRepository());
        final userExists = await userRepository.fetchUserDetails();

        if (userExists.id.isEmpty) {
          final user = UserModel(
            id: userCredentials.user!.uid,
            firstName: userCredentials.user!.displayName ?? '',
            lastName: '',
            username: UserModel.generateUsername(
              userCredentials.user!.displayName ?? '',
            ),
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
          );

          await userRepository.saveUserRecord(user);
        }

        // Redirect
        AuthenticationRepository.instance.screenRedirect();
      }

      // Remove Loader
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      ErrorHandler.showError(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage: 'Google sign-in failed.',
      );
    }
  }
}
