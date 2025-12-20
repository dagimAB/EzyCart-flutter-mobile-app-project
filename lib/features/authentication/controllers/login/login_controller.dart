import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/data/repositories/user/user_repository.dart';
import 'package:ezycart/features/personalization/models/user_model.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      // Start Loading
      isLoading.value = true;

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      // Login user using Email & Password Authentication
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // Remove Loader
      isLoading.value = false;

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      isLoading.value = false;
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
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
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
