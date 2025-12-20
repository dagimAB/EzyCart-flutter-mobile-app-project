import 'package:ezycart/common/widgets/products/cart/add_remove_button.dart';
import 'package:ezycart/common/widgets/products/cart/cart_item.dart';
import 'package:ezycart/common/widgets/texts/product_price_text.dart';
import 'package:ezycart/features/shop/controllers/cart_controller.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ECartItems extends StatelessWidget {
  const ECartItems({
    super.key,
    this.showAddRemoveButtons = true,
    this.scrollable = true,
  });

  final bool showAddRemoveButtons;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return Obx(
      () => ListView.separated(
        shrinkWrap: true,
        physics: scrollable
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) =>
            const SizedBox(height: ESizes.spaceBtwSections),
        itemCount: controller.cartItems.length,
        itemBuilder: (_, index) => Column(
          children: [
            // Cart Item
            ECartItem(cartItem: controller.cartItems[index]),
            if (showAddRemoveButtons)
              const SizedBox(height: ESizes.spaceBtwItems),

            // Add Remove Button Row with total Price
            if (showAddRemoveButtons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Extra Space
                      const SizedBox(width: 70),
                      // Add Remove Buttons
                      EProductQuantityWithAddRemoveButton(
                        quantity: controller.cartItems[index].quantity,
                        add: () => controller.addOneToCart(
                          controller.cartItems[index],
                        ),
                        remove: () => controller.removeOneFromCart(
                          controller.cartItems[index],
                        ),
                      ),
                    ],
                  ),
                  // Product total Price
                  EProductPriceText(
                    price:
                        (controller.cartItems[index].price *
                                controller.cartItems[index].quantity)
                            .toStringAsFixed(1),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
