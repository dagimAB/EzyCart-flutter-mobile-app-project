import 'package:ezycart/features/authentication/screens/signup/verify_email.dart';
import 'package:ezycart/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ESignupForm extends StatelessWidget {
  const ESignupForm({super.key});

  @override
  Widget build(BuildContext context) {

    return Form(
      child: Column(
        children: [
          /// First Name & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: ETexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: ESizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: ETexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Username
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: ETexts.username,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          // Email
          TextFormField(
            decoration: const InputDecoration(
              labelText: ETexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            decoration: const InputDecoration(
              labelText: ETexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          // Password
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: ETexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwSections),



          // Terms & Conditions Checkbox
          const ETermsAndConditionCheckbox(),
          const SizedBox(height: ESizes.spaceBtwSections),

          

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const VerifyEmailScreen()),
              child: const Text(ETexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}



