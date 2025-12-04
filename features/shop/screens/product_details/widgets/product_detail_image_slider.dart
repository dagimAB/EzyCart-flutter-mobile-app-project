import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:ezycart/common/widgets/icons/e_circular_icon.dart';
import 'package:ezycart/common/widgets/images/e_rounded_image.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EProductImageSlider extends StatelessWidget {
  const EProductImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return ECurvedEdgesWidget(
      child: Container(
        color: dark ? EColors.darkerGrey : EColors.light,
        child: Stack(
          children: [
            // Main Large Image
            const SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(ESizes.productImageRadius * 2),
                child: Center(
                  child: Image(image: AssetImage(EImages.productImage1)),
                ),
              ),
            ),

            // Image Slider
            Positioned(
              right: 0,
              bottom: 30,
              left: ESizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  itemCount: 6,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: ESizes.spaceBtwItems),
                  itemBuilder: (_, index) => ERoundedImage(
                    width: 80,
                    backgroundColor: dark ? EColors.dark : EColors.white,
                    border: Border.all(color: EColors.primary),
                    padding: const EdgeInsets.all(ESizes.sm),
                    imageUrl: EImages.productImage1,
                  ),
                ),
              ),
            ),

            // Appbar Icons
            const EAppBar(
              showBackArrow: true,
              actions: [ECircularIcon(icon: Iconsax.heart5, color: Colors.red)],
            ),
          ],
        ),
      ),
    );
  }
}
