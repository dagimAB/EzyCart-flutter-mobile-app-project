import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ESocialButtons extends StatelessWidget {
  const ESocialButtons({super.key, this.onGooglePressed});

  final VoidCallback? onGooglePressed;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: EColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: onGooglePressed,
            icon: Image.asset(
              dark ? EImages.googleDark : EImages.google,
              width: ESizes.iconMd,
              height: ESizes.iconMd,
            ),
          ),
        ),
      ],
    );
  }
}
