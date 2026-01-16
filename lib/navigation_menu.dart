import 'package:ezycart/features/personalization/screens/settings/settings.dart';
import 'package:ezycart/features/shop/screens/cart/cart.dart';
import 'package:ezycart/features/shop/screens/home/home.dart';
import 'package:ezycart/features/shop/screens/store/store.dart';
import 'package:ezycart/features/shop/screens/wishlist/wishlist.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80, // Restored height for better visibility
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? EColors.black : EColors.white,
          indicatorColor: darkMode
              ? EColors.white.withValues(alpha: 0.1)
              : EColors.black.withValues(alpha: 0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.shop), label: 'Store'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'Wishlist'),
            NavigationDestination(
              icon: Icon(Iconsax.shopping_cart),
              label: 'Cart',
            ),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const StoreScreen(),
    const FavouriteScreen(),
    const CartScreen(),
    const SettingsScreen(),
  ];
}
