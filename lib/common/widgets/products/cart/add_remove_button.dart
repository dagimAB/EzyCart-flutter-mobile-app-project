import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ezycart/common/widgets/icons/e_circular_icon.dart';

class EProductQuantityWithAddRemoveButton extends StatelessWidget {
  const EProductQuantityWithAddRemoveButton({
    super.key,
    required this.quantity,
    this.add,
    this.remove,
  });

  final int quantity;
  final VoidCallback? add, remove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ECircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: ESizes.md,
          color: EHelperFunctions.isDarkMode(context)
              ? EColors.white
              : EColors.black,
          backgroundColor: EHelperFunctions.isDarkMode(context)
              ? EColors.darkerGrey
              : EColors.light,
          onPressed: remove,
        ),
        const SizedBox(width: ESizes.spaceBtwItems),
        Text(
          quantity.toString(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: ESizes.spaceBtwItems),
        ECircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: ESizes.md,
          color: EColors.white,
          backgroundColor: EColors.primary,
          onPressed: add,
        ),
      ],
    );
  }
}
