import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:ezycart/features/authentication/screens/login/login.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
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
      try {
        // Check if AuthenticationRepository is registered
        if (Get.isRegistered<AuthenticationRepository>()) {
          AuthenticationRepository.instance.screenRedirect();
        } else {
          // If not registered yet (rare race condition), try to put it or wait
          Get.put(AuthenticationRepository()).screenRedirect();
        }
      } catch (e) {
        // If initialization fails (e.g., Firebase not available in tests), fallback to Login
        debugPrint('Error initializing AuthenticationRepository in Splash: $e');
        Get.offAll(() => LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? EColors.dark : EColors.light,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // Adjust radius as needed
                  child: Image.asset(
                    dark ? EImages.lightAppLogo : EImages.darkAppLogo,
                    width: Get.width * 0.5,
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtwSections),
                const CircularProgressIndicator(color: EColors.primary),
              ],
            ),
          ),
          if (kDebugMode)
            Positioned(
              right: 8,
              top: 8,
              child: SafeArea(
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/diagnostics'),
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Diagnostics'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
