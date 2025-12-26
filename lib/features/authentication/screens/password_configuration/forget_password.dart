import 'package:ezycart/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

// Added imports for password reset flow
import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/utils/popups/loaders.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ELoaders.warningSnackBar(
        title: 'Invalid',
        message: 'Please enter your email',
      );
      return;
    }

    try {
      setState(() => _loading = true);
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);
      ELoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Password reset email has been sent',
      );
      Get.off(() => ResetPassword(email: email));
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

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
              controller: _emailController,
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
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(ETexts.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
