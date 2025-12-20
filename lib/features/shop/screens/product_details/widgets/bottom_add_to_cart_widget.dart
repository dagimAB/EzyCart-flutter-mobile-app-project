import 'package:ezycart/features/shop/controllers/cart_controller.dart';
import 'package:ezycart/features/shop/models/cart_item_model.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:ezycart/common/widgets/icons/e_circular_icon.dart';

class EBottomAddToCart extends StatelessWidget {
  const EBottomAddToCart({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    controller.updateAlreadyAddedProductCount(product.id);
    final dark = EHelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ESizes.defaultSpace,
        vertical: ESizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? EColors.darkerGrey : EColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(ESizes.cardRadiusLg),
          topRight: Radius.circular(ESizes.cardRadiusLg),
        ),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ECircularIcon(
                  icon: Iconsax.minus,
                  backgroundColor: EColors.darkGrey,
                  width: 40,
                  height: 40,
                  color: EColors.white,
                  onPressed: () => controller.productQuantityInCart.value < 1
                      ? null
                      : controller.productQuantityInCart.value -= 1,
                ),
                const SizedBox(width: ESizes.spaceBtwItems),
                Text(
                  controller.productQuantityInCart.value.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: ESizes.spaceBtwItems),
                ECircularIcon(
                  icon: Iconsax.add,
                  backgroundColor: EColors.black,
                  width: 40,
                  height: 40,
                  color: EColors.white,
                  onPressed: () => controller.productQuantityInCart.value += 1,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: controller.productQuantityInCart.value < 1
                  ? null
                  : () => controller.addToCart(
                      CartItemModel(
                        productId: product.id,
                        quantity: controller.productQuantityInCart.value,
                        variationId: '',
                        image: product.image,
                        title: product.title,
                        brandName: product.brand?.name,
                        price: product.salePrice ?? product.price,
                        selectedVariation: null,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(ESizes.md),
                backgroundColor: EColors.black,
                side: const BorderSide(color: EColors.black),
              ),
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
