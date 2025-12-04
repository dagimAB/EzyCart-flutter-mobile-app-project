import 'package:ezycart/common/styles/spacing_styles.dart';
import 'package:ezycart/common/widgets/login_signup/form_divider.dart';
import 'package:ezycart/common/widgets/login_signup/social_buttons.dart';
import 'package:ezycart/features/authentication/screens/login/widgets/login_form.dart';
import 'package:ezycart/features/authentication/screens/login/widgets/login_header.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          // ESpacingStyle
          padding: ESpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [

              /// Logo, Title & Sub-Title
              const ELoginHeader(),


              /// Form
              const ELoginForm(),


              /// Divider
              EFormDivider(dividerText: ETexts.orSignInWith.capitalize!),
              const SizedBox(height: ESizes.spaceBtwSections),


              /// Footer
              const ESocialButtons(),

            ],
          ),
        ),
      ),
    );
  }
}
