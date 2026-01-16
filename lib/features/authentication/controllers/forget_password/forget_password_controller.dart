import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/errors/error_handler.dart';
import 'package:ezycart/utils/popups/full_screen_loader.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  // Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Resest Password Email
  sendPasswordResetEmail() async {
    try {
      // 1. Start Loading
      EFullScreenLoader.openLoadingDialog(
        'Processing your request...',
        EImages.processingGear,
      );

      // 2. Validate Form
      if (!forgetPasswordFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // 3. Send Email
      await AuthenticationRepository.instance.sendPasswordResetEmail(
        email.text.trim(),
      );

      // 4. Stop Loading
      EFullScreenLoader.stopLoading();

      // 5. Show Success Screen
      ELoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Email Link Sent to Reset your Password'.tr,
      );

      // 6. Redirect to ResetPassword Screen
      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();
      ErrorHandler.showError(error: e, title: 'Oh Snap!');
    }
  }

  /// Resend Reset Password Email
  resendPasswordResetEmail(String email) async {
    try {
      // 1. Start Loading
      EFullScreenLoader.openLoadingDialog(
        'Processing your request...',
        EImages.processingGear,
      );

      // 2. Send Email using Repository
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // 3. Stop Loading
      EFullScreenLoader.stopLoading();

      // 4. Show Success Screen
      ELoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Email Link Sent to Reset your Password'.tr,
      );
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();
      ErrorHandler.showError(error: e, title: 'Oh Snap!');
    }
  }
}
