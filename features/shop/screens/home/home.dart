import 'package:ezycart/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/shop/screens/all_products/all_products.dart';
import 'package:ezycart/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ezycart/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ezycart/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            const EPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  EHomeAppBar(),
                  SizedBox(height: ESizes.spaceBtwSections),

                  /// SearchBar
                  ESearchContainer(text: 'Search in Store'),
                  SizedBox(height: ESizes.spaceBtwSections),

                  /// Categories
                  Padding(
                    padding: EdgeInsets.only(left: ESizes.defaultSpacing),
                    child: Column(
                      children: [
                        /// Section Heading
                        ESectionHeading(
                          title: "Popular Categories",
                          showActionButton: false,
                          textColor: EColors.white,
                        ),
                        SizedBox(height: ESizes.spaceBtwItems),

                        /// Categories List
                        EHomeCategories(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body Section
            Padding(
              padding: const EdgeInsets.all(ESizes.defaultSpacing),
              child: Column(
                children: [
                  //Promo Slider
                  const EPromoSlider(
                    banners: [
                      EImages.bannerImage1,
                      EImages.bannerImage2,
                      EImages.bannerImage3,
                    ],
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),

                  ///Popular Products Section
                  ESectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => const AllProducts()),
                  ),
                  const SizedBox(height: ESizes.spaceBtwItems),

                  EGridLayout(
                    itemCount: 4,
                    itemBuilder: (_, index) => const EProductCardVertical(),
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
