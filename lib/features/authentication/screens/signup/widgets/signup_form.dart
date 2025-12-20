import 'package:ezycart/features/authentication/controllers/signup/signup_controller.dart';
import 'package:ezycart/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:ezycart/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ESignupForm extends StatelessWidget {
  const ESignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          /// First Name & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      EValidator.validateEmptyText('First name', value),
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
                  controller: controller.lastName,
                  validator: (value) =>
                      EValidator.validateEmptyText('Last name', value),
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
            controller: controller.username,
            validator: (value) =>
                EValidator.validateEmptyText('Username', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: ETexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: (value) => EValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: ETexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => EValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
              labelText: ETexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => EValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: ETexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon: Icon(
                    controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Confirm Password
          Obx(
            () => TextFormField(
              controller: controller.confirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm Password is required.';
                }
                if (value != controller.password.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
              obscureText: controller.hideConfirmPassword.value,
              decoration: InputDecoration(
                labelText: ETexts.confirmPassword,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                  onPressed: () => controller.hideConfirmPassword.value =
                      !controller.hideConfirmPassword.value,
                  icon: Icon(
                    controller.hideConfirmPassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwSections),

          // Terms & Conditions Checkbox
          const ETermsAndConditionCheckbox(),
          const SizedBox(height: ESizes.spaceBtwSections),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? () {}
                    : () => controller.signup(),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(ETexts.createAccount),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
