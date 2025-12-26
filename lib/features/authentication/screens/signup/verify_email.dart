import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () =>
                AuthenticationRepository.instance.confirmAndLogout(),
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
              const SizedBox(height: ESizes.spaceBtwItems),
              Text(
                email ?? '',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

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
                  onPressed: () => controller.checkEmailVerificationStatus(),
                  child: const Text(ETexts.eContinue),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => controller.sendEmailVerification(),
                  child: const Text(ETexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
