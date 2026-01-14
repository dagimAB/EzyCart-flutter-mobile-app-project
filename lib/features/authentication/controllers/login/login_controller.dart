import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/data/repositories/user/user_repository.dart';
import 'package:ezycart/features/personalization/models/user_model.dart';
import 'package:ezycart/utils/security/security_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ezycart/utils/errors/error_handler.dart';
import 'package:ezycart/utils/popups/loaders.dart';

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
    try {
      // 1. Check Internet (Basic check using lookup, or rely on Firebase timeout)
      // For now, we rely on Firebase throwing error if offline.

      // 2. Form Validation
      if (!loginFormKey.currentState!.validate()) {
        debugPrint('Form validation failed');
        return;
      }

      // 3. Start Loading
      isLoading.value = true;
      debugPrint('Attempting login for: ${email.text.trim()}');

      // 4. Login user (try raw first, then fall back to hashed accounts created before this fix).
      final emailAddress = email.text.trim();
      final rawPassword = password.text.trim();

      await _loginWithFallback(emailAddress, rawPassword);

      // 5. Redirect (AuthenticationRepository handles this usually, but we call it explicitly)
      debugPrint('Login success, redirecting...');
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // The Repository already throws user-friendly Strings
      // So we just display them directly.
      debugPrint('emailAndPasswordSignIn error: $e');

      ELoaders.errorSnackBar(title: 'Login Failed', message: e.toString());
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

  Future<void> _loginWithFallback(String email, String rawPassword) async {
    try {
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email,
        rawPassword,
      );
    } on String catch (message) {
      final hashedPassword = hashPassword(rawPassword);
      final shouldRetry =
          (message == 'Incorrect password.' ||
              message == 'Invalid Email or Password.') &&
          hashedPassword != rawPassword;

      if (!shouldRetry) {
        rethrow;
      }

      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email,
        hashedPassword,
      );
    }
  }
}
