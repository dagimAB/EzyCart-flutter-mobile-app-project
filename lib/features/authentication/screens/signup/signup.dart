import 'package:ezycart/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ezycart/common/widgets/login_signup/form_divider.dart';
import 'package:ezycart/common/widgets/login_signup/social_buttons.dart';
import 'package:ezycart/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                ETexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Form
              const ESignupForm(),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Divider
              EFormDivider(dividerText: ETexts.orSignUpWith.capitalize!),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Social Buttons
              ESocialButtons(onGooglePressed: () => controller.googleSignIn()),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
