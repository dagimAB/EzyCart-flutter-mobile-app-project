import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EProductImageSlider extends StatelessWidget {
  const EProductImageSlider({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return ECurvedEdgesWidget(
      child: Container(
        color: dark ? EColors.darkerGrey : EColors.light,
        child: Stack(
          children: [
            // Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(ESizes.productImageRadius * 2),
                child: Center(
                  child: imageUrl.startsWith('http')
                      ? Image.network(imageUrl)
                      : Image(image: AssetImage(imageUrl)),
                ),
              ),
            ),

            // Appbar Icons
            const EAppBar(showBackArrow: true, actions: []),
          ],
        ),
      ),
    );
  }
}
