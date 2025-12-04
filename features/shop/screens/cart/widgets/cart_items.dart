import 'package:ezycart/common/widgets/products/cart/add_remove_button.dart';
import 'package:ezycart/common/widgets/products/cart/cart_item.dart';
import 'package:ezycart/common/widgets/texts/product_price_text.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ECartItems extends StatelessWidget {
  const ECartItems({super.key, this.showAddRemoveButtons = true});

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) =>
          const SizedBox(height: ESizes.spaceBtwSections),
      itemCount: 2,
      itemBuilder: (_, index) => Column(
        children: [
          // Cart Item
          const ECartItem(),
          if (showAddRemoveButtons)
            const SizedBox(height: ESizes.spaceBtwItems),

          // Add Remove Button Row with total Price
          if (showAddRemoveButtons)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Extra Space
                    SizedBox(width: 70),
                    // Add Remove Buttons
                    EProductQuantityWithAddRemoveButton(),
                  ],
                ),
                // Product total Price
                EProductPriceText(price: '256'),
              ],
            ),
        ],
      ),
    );
  }
}
