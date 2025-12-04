import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ELoginHeader extends StatelessWidget {
  const ELoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(45.0),
            child: Image(
              height: 150,
              image: AssetImage(
                dark ? EImages.darkAppLogo : EImages.lightAppLogo,
              ),
            ),
          ),
          // ----------------------------------------------------
          const SizedBox(
            height: ESizes.sm,
          ), 

          Text(
            ETexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ESizes.sm),
          Text(
            ETexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
