import 'package:ezycart/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:get/get.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/device/device_utility.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Positioned(
      right: ESizes.defaultSpacing,
      bottom: EDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () {
          final controller = Get.isRegistered<OnBoardingController>()
              ? OnBoardingController.instance
              : Get.put(OnBoardingController());
          controller.nextPage();
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: dark ? EColors.primary : Colors.black,
        ),
        child: const Icon(Iconsax.arrow_right_3),
      ), // ElevatedButton
    ); // Positioned
  }
}
