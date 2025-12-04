import 'package:ezycart/common/widgets/success_screen/success_screen.dart';
import 'package:ezycart/features/authentication/screens/login/login.dart';

import 'package:ezycart/utils/constants/image_strings.dart';

import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';

import 'package:ezycart/utils/helpers/helper_functions.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';





class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),

            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),

      body: SingleChildScrollView(
        // Padding to Give Default Equal Space on all sides in all screens.
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpacing),
          child: Column(
            children: [
              /// Image
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),

                  child: Image(
                    image: const AssetImage(EImages.deliveredEmailIllustration),
                    width: EHelperFunctions.screenWidth() * 0.7,
                  ),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              /// Title & Subtitle
              Text(
                ETexts.confirmEmailTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              Text(
                'support@dagimabraham.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),
              Text(
                ETexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(
                    () => SuccessScreen(
                      image: EImages.staticSuccessIllustration,
                      title: ETexts.yourAccountCreatedTitle,
                      subtitle: ETexts.yourAccountCreatedSubTitle,
                      onPressed: () => Get.to(() => const LoginScreen()),
                    ),
                  ),
                  child: const Text(ETexts.eContinue),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: Text(ETexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
