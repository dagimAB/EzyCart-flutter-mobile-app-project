import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/device/device_utility.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ESearchContainer extends StatelessWidget {
  const ESearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
  });

  final String text;
  final IconData? icon;
  final bool showBackground;
  final bool showBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ESizes.defaultSpacing),
        child: Container(
          width: EDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(ESizes.md),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                      ? EColors.dark
                      : EColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(ESizes.cardRadiusLg),
            border: showBorder ? Border.all(color: EColors.grey) : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: EColors.darkerGrey),
              const SizedBox(width: ESizes.spaceBtwItems),
              Text(text, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
