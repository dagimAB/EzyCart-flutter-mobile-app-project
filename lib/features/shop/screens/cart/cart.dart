import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/features/shop/controllers/cart_controller.dart';
import 'package:ezycart/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:ezycart/features/shop/screens/checkout/checkout.dart';
import 'package:ezycart/navigation_menu.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Scaffold(
      appBar: EAppBar(
        leadingOnPressed: () {
          // If this screen was pushed (e.g., from icon tap), pop back.
          // If not (we're inside the main NavigationMenu), switch to Home tab.
          if (Navigator.of(context).canPop()) {
            Get.back();
          } else {
            Get.find<NavigationController>().selectedIndex.value = 0;
          }
        },
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(child: Text('Whoops! Cart is Empty.'));
        } else {
          return const Padding(
            padding: EdgeInsets.all(ESizes.defaultSpace),
            child: ECartItems(),
          );
        }
      }),
      bottomNavigationBar: Obx(
        () => controller.cartItems.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(ESizes.defaultSpace),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const CheckoutScreen()),
                  child: Text(
                    'Checkout \$${controller.totalCartPrice.value.toStringAsFixed(1)}',
                  ),
                ),
              ),
      ),
    );
  }
}
