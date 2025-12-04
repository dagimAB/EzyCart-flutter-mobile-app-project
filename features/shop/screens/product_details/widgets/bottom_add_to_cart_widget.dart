import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:ezycart/common/widgets/icons/e_circular_icon.dart';

class EBottomAddToCart extends StatelessWidget {
  const EBottomAddToCart({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ESizes.defaultSpace,
        vertical: ESizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? EColors.darkerGrey : EColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(ESizes.cardRadiusLg),
          topRight: Radius.circular(ESizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ECircularIcon(
                icon: Iconsax.minus,
                backgroundColor: EColors.darkGrey,
                width: 40,
                height: 40,
                color: EColors.white,
                onPressed: () {},
              ),
              const SizedBox(width: ESizes.spaceBtwItems),
              Text('2', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: ESizes.spaceBtwItems),
              ECircularIcon(
                icon: Iconsax.add,
                backgroundColor: EColors.black,
                width: 40,
                height: 40,
                color: EColors.white,
                onPressed: () {},
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(ESizes.md),
              backgroundColor: EColors.black,
              side: const BorderSide(color: EColors.black),
            ),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
