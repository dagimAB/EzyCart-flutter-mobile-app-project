import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/data/repositories/user/user_repository.dart';
import 'package:ezycart/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ezycart/utils/errors/error_handler.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;

  // -- Loading
  final isLoading = false.obs;

  /// -- Login
  Future<void> emailAndPasswordSignIn() async {
    isLoading.value = true;
    try {
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        return;
      }

      // Login user using Email & Password Authentication
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e, st) {
      debugPrint('emailAndPasswordSignIn error: $e');
      debugPrintStack(stackTrace: st);
      ErrorHandler.showError(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage:
            'Login failed. Please check your credentials and connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// -- Google SignIn
  Future<void> googleSignIn() async {
    isLoading.value = true;
    try {
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
    } catch (e, st) {
      debugPrint('googleSignIn error: $e');
      debugPrintStack(stackTrace: st);
      ErrorHandler.showError(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage: 'Google sign-in failed.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
