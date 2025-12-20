import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ezycart/features/shop/controllers/search_controller.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ESearchController());

    return Scaffold(
      appBar: EAppBar(
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              // Search Bar
              TextFormField(
                onChanged: (value) => controller.searchProducts(value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.search_normal),
                  labelText: 'Search Products',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              // Results
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.searchResults.isEmpty) {
                  return const Center(child: Text('No Products Found'));
                }

                return EGridLayout(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (_, index) => EProductCardVertical(
                    product: controller.searchResults[index],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
