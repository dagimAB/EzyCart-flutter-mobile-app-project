import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/common/widgets/images/e_circular_image.dart';
import 'package:ezycart/common/widgets/texts/e_brand_title_with_verified_icon.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/enums.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EBrandCard extends StatelessWidget {
  const EBrandCard({
    super.key,
    this.onTap,
    required this.showBorder,
    required this.title,
    required this.image,
  });

  final bool showBorder;
  final void Function()? onTap;
  final String title, image;

  @override
  Widget build(BuildContext context) {
    final isDark = EHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: ERoundedContainer(
        showBorder: showBorder,
        backgroundColor: isDark ? Colors.transparent : EColors.white,
        padding: const EdgeInsets.all(ESizes.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // -- Icon
            Flexible(
              child: ECircularImage(
                isNetworkImage: false,
                image: image,
                backgroundColor: Colors.transparent,
                overlayColor: isDark ? EColors.white : EColors.black,
              ),
            ),
            const SizedBox(width: ESizes.spaceBtwItems / 2),

            // -- Text
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EBrandTitleWithVerifiedIcon(
                    title: title,
                    brandTextSize: TextSize.large,
                  ),
                  Text(
                    '256 products',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
