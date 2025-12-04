import 'package:ezycart/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(ESizes.defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            // Headings
            Text(
              ETexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: ESizes.spaceBtwItems),
            Text(
              ETexts.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: ESizes.spaceBtwSections * 2),

            // Text field
            TextFormField(
              decoration: const InputDecoration(
                labelText: ETexts.email,
                prefixIcon: Icon(Iconsax.direct_right),
              ),
            ), 
            const SizedBox(height: ESizes.spaceBtwSections),

            /// submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.off(() => const ResetPassword()),
                child: const Text(ETexts.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
