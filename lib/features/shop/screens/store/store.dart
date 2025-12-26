import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:ezycart/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:ezycart/features/shop/controllers/category_controller.dart';
import 'package:ezycart/features/shop/screens/cart/cart.dart';
import 'package:ezycart/features/shop/screens/search/search.dart';
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
    final categoryController = CategoryController.instance;

    return Obx(() {
      if (categoryController.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (categoryController.featuredCategories.isEmpty) {
        return Scaffold(
          appBar: EAppBar(
            title: Text(
              'Store',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: const Center(child: Text('No Categories Found!')),
        );
      }

      return DefaultTabController(
        length: categoryController.featuredCategories.length,
        child: Scaffold(
          appBar: EAppBar(
            showBackArrow: false,
            title: Text(
              'Store',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            actions: [
              ECartCounterIcon(
                onPressed: () => Get.to(() => const CartScreen()),
                iconColor: EHelperFunctions.isDarkMode(context)
                    ? EColors.white
                    : EColors.black,
              ),
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
                  expandedHeight: 160, // Space for Search Bar
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(ESizes.defaultSpace),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: ESizes.spaceBtwItems),
                        ESearchContainer(
                          text: 'Search in Store',
                          showBorder: true,
                          showBackground: false,
                          onTap: () => Get.to(() => const SearchScreen()),
                        ),
                        const SizedBox(height: ESizes.spaceBtwSections),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: EColors.primary,
                    unselectedLabelColor: EColors.darkGrey,
                    labelColor: EColors.primary,
                    tabs: categoryController.featuredCategories
                        .map((category) => Tab(child: Text(category.name)))
                        .toList(),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: categoryController.featuredCategories
                  .map((category) => ECategoryTab(category: category))
                  .toList(),
            ),
          ),
        ),
      );
    });
  }
}
