import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/images/e_rounded_image.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EAppBar(title: Text('Sports'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              // Banner
              const ERoundedImage(
                width: double.infinity,
                imageUrl: EImages.bannerImage3,
                applyImageRadius: true,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              // Sub-Categories
              Column(
                children: [
                  // Heading
                  ESectionHeading(title: 'Sports Shirts', onPressed: () {}),
                  const SizedBox(height: ESizes.spaceBtwItems / 2),

                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: ESizes.spaceBtwItems),
                      itemBuilder: (context, index) =>
                          const EProductCardHorizontal(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
