import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EVerticalImageText extends StatelessWidget {
  const EVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = EColors.white,
    this.backgroundColor = EColors.white,
    this.onTap,
    this.isNetworkImage = false,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: ESizes.spaceBtwItems),
        child: Column(
          children: [
            /// Circular Icon
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(ESizes.sm),
              decoration: BoxDecoration(
                color:
                    backgroundColor ?? (dark ? EColors.black : EColors.white),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: isNetworkImage
                    ? Image.network(image, fit: BoxFit.cover)
                    : Image(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                        // color: dark ? EColors.light : EColors.dark,
                      ),
              ),
            ),

            /// Category Name or Text
            const SizedBox(height: ESizes.spaceBtwItems / 2),
            SizedBox(
              width: 55,
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.apply(color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
