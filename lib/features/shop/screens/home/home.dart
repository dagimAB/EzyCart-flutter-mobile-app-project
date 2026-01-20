import 'package:ezycart/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/shop/screens/all_products/all_products.dart';
import 'package:ezycart/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ezycart/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ezycart/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:ezycart/features/shop/screens/search/search.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:ezycart/features/shop/controllers/product_controller.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:get/get.dart';
import 'package:ezycart/features/ai_assistant/screens/chat_screen.dart';

// Fix: Ensure Home screen rebuilds correctly
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            EPrimaryHeaderContainer(
              // Wrap the Column to ensure it doesn't overflow the primary container
              child: Column(
                children: [
                  const EHomeAppBar(),
                  const SizedBox(height: ESizes.spaceBtwSections),
                  ESearchContainer(
                    text: 'Search in Store',
                    onTap: () => Get.to(() => const SearchScreen()),
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: ESizes.defaultSpace,
                      right: ESizes.defaultSpace,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: ESectionHeading(
                                title: 'Popular Categories',
                                showActionButton: false,
                                textColor: EColors.white,
                              ),
                            ),
                            Tooltip(
                              message: 'AI Assistant',
                              preferBelow: false,
                              child: GestureDetector(
                                onTap: () => Get.to(() => const ChatScreen()),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: EColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/logos/ai_logo.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: ESizes.spaceBtwItems),
                        const EHomeCategories(), // This now has a height of 100 internally
                      ],
                    ),
                  ),
                  // This SizedBox creates the necessary "buffer" at the bottom of the blue area
                  const SizedBox(height: ESizes.spaceBtwSections * 1.5),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(ESizes.defaultSpace),
              child: Column(
                children: [
                  const EPromoSlider(
                    banners: [
                      EImages.promoBanner1,
                      EImages.promoBanner2,
                      EImages.promoBanner3,
                    ],
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),
                  const SizedBox(height: ESizes.spaceBtwSections),
                  ESectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => const AllProducts()),
                  ),
                  const SizedBox(height: ESizes.spaceBtwItems),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.featuredProducts.isEmpty) {
                      return const Center(child: Text('No Data Found!'));
                    }

                    return EGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) {
                        return EProductCardVertical(
                          product: controller.featuredProducts[index],
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
