import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/icons/e_circular_icon.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/loaders/animation_loader.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ezycart/features/shop/controllers/favourites_controller.dart';
import 'package:ezycart/navigation_menu.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouritesController.instance;
    return Scaffold(
      appBar: EAppBar(
        leadingOnPressed: () {
          final nav = Get.isRegistered<NavigationController>()
              ? Get.find<NavigationController>()
              : Get.put(NavigationController());
          nav.selectedIndex.value = 0;
        },
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          ECircularIcon(
            icon: Iconsax.add,
            onPressed: () {
              final nav = Get.isRegistered<NavigationController>()
                  ? Get.find<NavigationController>()
                  : Get.put(NavigationController());
              nav.selectedIndex.value = 0;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Obx(() {
            // Rebuild UI when favorites map changes
            if (controller.favorites.isEmpty) {
              return EAnimationLoaderWidget(
                text: 'Whoops! Wishlist is Empty...',
                // Use a proper "Empty/Search" animation instead of the default loader
                animation: EImages.onBoardingImage1,
                showAction: true,
                actionText: 'Let\'s add some',
                onActionPressed: () =>
                    Get.find<NavigationController>().selectedIndex.value = 0,
              );
            }

            return FutureBuilder(
              future: controller.favoriteProducts(),
              builder: (context, snapshot) {
                final emptyWidget = EAnimationLoaderWidget(
                  text: 'Whoops! Wishlist is Empty...',
                  // Use a proper "Empty/Search" animation instead of the default loader
                  animation: EImages.onBoardingImage1,
                  showAction: true,
                  actionText: 'Let\'s add some',
                  onActionPressed: () =>
                      Get.find<NavigationController>().selectedIndex.value = 0,
                );

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Something went wrong!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return emptyWidget;
                }

                final products = snapshot.data!;

                return EGridLayout(
                  itemCount: products.length,
                  itemBuilder: (_, index) =>
                      EProductCardVertical(product: products[index]),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
