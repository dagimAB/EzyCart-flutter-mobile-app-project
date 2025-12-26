import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Added imports for password reset resend + navigation
import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:ezycart/features/authentication/screens/login/login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, this.email});

  final String? email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _loading = false;

  Future<void> _resend() async {
    final email = widget.email;
    if (email == null || email.isEmpty) {
      ELoaders.warningSnackBar(
        title: 'Missing',
        message: 'No email available to resend',
      );
      return;
    }

    try {
      setState(() => _loading = true);
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);
      ELoaders.successSnackBar(
        title: ETexts.changeYourPasswordTitle,
        message: 'Password reset email sent',
      );
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpacing),
          child: Column(
            children: [
              /// Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),

                  child: Image(
                    image: const AssetImage(EImages.deliveredEmailIllustration),
                    width: EHelperFunctions.screenWidth() * 0.7,
                  ),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Title & Subtitle
              Text(
                ETexts.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              Text(
                widget.email ?? ETexts.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                  child: Text(ETexts.done),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _loading ? null : _resend,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : Text(ETexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
