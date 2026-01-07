import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ELoaders {
  static hideSnackBar() {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
    } else {
      debugPrint('hideSnackBar called but no context available');
    }
  }

  static customToast({required String message}) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          elevation: 0,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: EHelperFunctions.isDarkMode(Get.context!)
                  ? EColors.darkerGrey.withOpacity(0.9)
                  : EColors.grey.withOpacity(0.9),
            ),
            child: Center(
              child: Text(
                message,
                style: Theme.of(Get.context!).textTheme.labelLarge,
              ),
            ),
          ),
        ),
      );
    } else {
      debugPrint('customToast: $message');
    }
  }

  static successSnackBar({
    required String title,
    String message = '',
    int duration = 3,
  }) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: EColors.primary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: duration),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Iconsax.check, color: EColors.white),
      );
    } else {
      debugPrint('$title: $message');
    }
  }

  static warningSnackBar({required String title, String message = ''}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: EColors.white),
      );
    } else {
      debugPrint('$title: $message');
    }
  }

  static errorSnackBar({required String title, String message = ''}) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: EColors.white),
      );
    } else {
      debugPrint('$title: $message');
    }
  }
}
