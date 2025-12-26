import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/common/widgets/images/e_rounded_image.dart';
import 'package:ezycart/common/widgets/texts/product_price_text.dart';
import 'package:ezycart/common/widgets/texts/product_title_text.dart';
import 'package:ezycart/features/shop/controllers/cart_controller.dart';
import 'package:ezycart/features/shop/models/brand_model.dart';
import 'package:ezycart/features/shop/models/cart_item_model.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/features/shop/screens/product_details/product_detail.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EProductCardHorizontal extends StatelessWidget {
  const EProductCardHorizontal({
    super.key,
    this.imageUrl = EImages.productImage1,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    final cartController = CartController.instance;

    // Create a dummy product for demonstration
    final product = ProductModel(
      id: 'dummy_id_horiz_${imageUrl.hashCode}',
      title: 'Green Nike Half Sleeves Shirt',
      stock: 15,
      price: 256.0,
      thumbnail: imageUrl,
      productType: 'Single',
      description: 'Comfortable green shirt for daily wear.',
      brand: BrandModel(id: '1', name: 'Nike', image: EImages.shoeIcon),
      images: [imageUrl, EImages.productImage1, EImages.productImage2],
      salePrice: 200.0,
    );

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        width: 310,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ESizes.productImageRadius),
          color: dark ? EColors.darkerGrey : EColors.softGrey,
        ),
        child: Row(
          children: [
            // Thumbnail
            ERoundedContainer(
              height: 120,
              padding: const EdgeInsets.all(ESizes.sm),
              backgroundColor: dark ? EColors.dark : EColors.light,
              child: Stack(
                children: [
                  // Thumbnail Image
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: ERoundedImage(
                      imageUrl: imageUrl,
                      applyImageRadius: true,
                    ),
                  ),

                  // Sale Tag
                  Positioned(
                    top: 12,
                    child: ERoundedContainer(
                      radius: ESizes.sm,
                      backgroundColor: EColors.secondary.withValues(alpha: 0.8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: ESizes.sm,
                        vertical: ESizes.xs,
                      ),
                      child: Text(
                        '25%',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.apply(color: EColors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            SizedBox(
              width: 172,
              child: Padding(
                padding: const EdgeInsets.only(top: ESizes.sm, left: ESizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EProductTitleText(
                          title: 'Green Nike Half Sleeves Shirt',
                          smallSize: true,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Pricing
                        const Flexible(
                          child: EProductPriceText(price: '256.0'),
                        ),

                        // Add to cart (reactive color)
                        Obx(() {
                          final added =
                              cartController.getProductQuantityInCart(
                                product.id,
                              ) >
                              0;
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
                              cartController.updateAlreadyAddedProductCount(
                                product.id,
                              );
                              ELoaders.customToast(
                                message: 'Product added to cart',
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: added ? EColors.success : EColors.dark,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(ESizes.cardRadiusMd),
                                  bottomRight: Radius.circular(
                                    ESizes.productImageRadius,
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
