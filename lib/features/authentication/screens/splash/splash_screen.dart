import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      // Check if AuthenticationRepository is registered
      if (Get.isRegistered<AuthenticationRepository>()) {
        AuthenticationRepository.instance.screenRedirect();
      } else {
        // If not registered yet (rare race condition), try to put it or wait
        Get.put(AuthenticationRepository()).screenRedirect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? EColors.dark : EColors.light,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              dark ? EImages.lightAppLogo : EImages.darkAppLogo,
              width: Get.width * 0.5,
            ),
            const SizedBox(height: ESizes.spaceBtwSections),
            const CircularProgressIndicator(color: EColors.primary),
          ],
        ),
      ),
    );
  }
}
