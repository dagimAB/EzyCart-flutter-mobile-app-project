import 'package:ezycart/common/styles/shadows.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/common/widgets/images/e_rounded_image.dart';
import 'package:ezycart/common/widgets/products/favourite_icon/favourite_icon.dart';
import 'package:ezycart/common/widgets/texts/product_price_text.dart';
import 'package:ezycart/common/widgets/texts/product_title_text.dart';
import 'package:ezycart/features/shop/controllers/cart_controller.dart';
import 'package:ezycart/features/shop/models/cart_item_model.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/features/shop/screens/product_details/product_detail.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

// Fix: Ensure library is loaded correctly
class EProductCardVertical extends StatelessWidget {
  const EProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;

    // Create a dummy product for demonstration
    // final product = ProductModel(
    //   id: 'dummy_id_${imageUrl.hashCode}',
    //   title: 'Brown Flat Shoes',
    //   stock: 15,
    //   price: 35.0,
    //   thumbnail: imageUrl,
    //   productType: 'Single',
    //   description: 'Comfortable brown flat shoes for daily wear.',
    //   brand: BrandModel(id: '1', name: 'Nike', image: EImages.shoeIcon),
    //   images: [imageUrl, EImages.productImage1, EImages.productImage2],
    //   salePrice: 30.0,
    // );

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [EShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(ESizes.productImageRadius),
          color: dark ? EColors.darkGrey : EColors.white,
        ),
        child: Column(
          children: [
            /// Thumbnail Image, whishList Icon, Discount Badge
            ERoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(ESizes.sm),
              backgroundColor: dark ? EColors.dark : EColors.light,
              child: Stack(
                children: [
                  /// Thumbnail Image
                  ERoundedImage(
                    imageUrl: product.thumbnail,
                    applyImageRadius: true,
                    isNetworkImage: product.thumbnail.startsWith('http'),
                  ),

                  /// -- Sale Badge
                  if (product.salePrice != null && product.salePrice! > 0)
                    Positioned(
                      top: 12,
                      child: ERoundedContainer(
                        radius: ESizes.sm,
                        backgroundColor: EColors.secondary.withAlpha(200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: ESizes.sm,
                          vertical: ESizes.xs,
                        ),
                        child: Text(
                          "${((product.price - product.salePrice!) / product.price * 100).round()}%",
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge!.apply(color: EColors.black),
                        ),
                      ),
                    ),

                  /// -- Favourite Icon
                  Positioned(
                    top: 0,
                    right: 0,
                    child: EFavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwItems / 2),

            /// Product Details
            Padding(
              padding: const EdgeInsets.only(left: ESizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EProductTitleText(title: product.title, smallSize: true),
                ],
              ),
            ),

            // Spacer to keep the price and add to cart button at the bottom
            const Spacer(),

            // Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Padding(
                  padding: const EdgeInsets.only(left: ESizes.sm),
                  child: product.salePrice != null && product.salePrice! > 0
                      ? Row(
                          children: [
                            EProductPriceText(
                              price: product.salePrice!.toStringAsFixed(2),
                              isLarge: true,
                            ),
                            const SizedBox(width: 8),
                            EProductPriceText(
                              price: product.price.toStringAsFixed(2),
                              lineThrough: true,
                            ),
                          ],
                        )
                      : EProductPriceText(
                          price: product.price.toStringAsFixed(2),
                        ),
                ),

                // Add to Cart Button (updates color when product is in cart)
                Obx(() {
                  final added =
                      cartController.getProductQuantityInCart(product.id) > 0;
                  return InkWell(
                    onTap: () {
                      final cartItem = CartItemModel(
                        productId: product.id,
                        quantity: 1,
                        variationId: '',
                        image: product.thumbnail,
                        title: product.title,
                        brandName: product.brand?.name,
                        price: product.salePrice ?? product.price,
                        selectedVariation: null,
                      );
                      cartController.addToCart(cartItem);
                      cartController.updateAlreadyAddedProductCount(product.id);
                      ELoaders.customToast(message: 'Product added to cart');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: added
                            ? EColors.success
                            : (dark ? EColors.dark : EColors.white),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(ESizes.cardRadiusMd),
                          bottomRight: Radius.circular(
                            ESizes.productImageRadius,
                          ),
                        ),
                        border: Border.all(
                          color: added
                              ? EColors.success
                              : EColors.borderPrimary,
                        ),
                      ),
                      child: SizedBox(
                        width: ESizes.iconLg * 1.2,
                        height: ESizes.iconLg * 1.2,
                        child: Center(
                          child: Icon(
                            added ? Iconsax.tick_circle : Iconsax.add,
                            color: EColors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
