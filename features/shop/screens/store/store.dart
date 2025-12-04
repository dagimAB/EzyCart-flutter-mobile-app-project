import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/brands/brand_card.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/shop/screens/brand/all_brands.dart';
import 'package:ezycart/features/shop/screens/store/widgets/category_tab.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: EAppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            ECartCounterIcon(onPressed: () {}, iconColor: EColors.black),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: EHelperFunctions.isDarkMode(context)
                    ? EColors.black
                    : EColors.white,
                expandedHeight: 440,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(ESizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // -- Search Bar
                      const SizedBox(height: ESizes.spaceBtwItems),
                      const ESearchContainer(
                        text: 'Search in Store',
                        showBorder: true,
                        showBackground: false,
                      ),
                      const SizedBox(height: ESizes.spaceBtwSections),

                      // -- Featured Brands
                      ESectionHeading(
                        title: 'Featured Brands',
                        onPressed: () => Get.to(() => const AllBrandsScreen()),
                      ),
                      const SizedBox(height: ESizes.spaceBtwItems / 1.5),

                      EGridLayout(
                        itemCount: 4,
                        mainAxisExtent: 80,
                        itemBuilder: (_, index) {
                          return const EBrandCard(showBorder: true);
                        },
                      ),
                    ],
                  ),
                ),

                // -- Tabs
                bottom: const TabBar(
                  isScrollable: true,
                  indicatorColor: EColors.primary,
                  unselectedLabelColor: EColors.darkGrey,
                  labelColor: EColors.primary,
                  tabs: [
                    Tab(child: Text('Sports')),
                    Tab(child: Text('Furniture')),
                    Tab(child: Text('Electronics')),
                    Tab(child: Text('Clothes')),
                    Tab(child: Text('Cosmetics')),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              ECategoryTab(),
              ECategoryTab(),
              ECategoryTab(),
              ECategoryTab(),
              ECategoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}
