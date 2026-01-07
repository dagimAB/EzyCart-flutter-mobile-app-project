import 'dart:async';
import 'package:ezycart/common/widgets/success_screen/success_screen.dart';
import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Needed for debugPrint
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  /// Send Email Whenever Verify Screen appears & Set Timer for auto redirect.
  @override
  void onInit() {
    super.onInit();
    // Send email after a slight delay to ensure UI is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      sendEmailVerification();
    });
    setTimerForAutoRedirect();
  }

  /// Send Email Verification link
  sendEmailVerification() async {
    try {
      debugPrint('Attempting to send verification email...');
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ELoaders.errorSnackBar(
          title: 'Error',
          message: 'User not found. Please log in again.',
        );
        return;
      }

      // Reload to ensure fresh state
      await user.reload();

      await AuthenticationRepository.instance.sendEmailVerification();

      debugPrint('Verification email sent to ${user.email}');
      ELoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Link sent to ${user.email}. Check Inbox/Spam.',
      );
    } catch (e) {
      debugPrint('Error sending verification email: $e');
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(
          () => SuccessScreen(
            image: EImages.staticSuccessIllustration,
            title: ETexts.yourAccountCreatedTitle,
            subtitle: ETexts.yourAccountCreatedSubTitle,
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          ),
        );
      }
    });
  }

  /// Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: EImages.staticSuccessIllustration,
          title: ETexts.yourAccountCreatedTitle,
          subtitle: ETexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );
    }
  }
}
