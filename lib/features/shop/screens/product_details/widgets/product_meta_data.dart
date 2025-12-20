import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/common/widgets/images/e_circular_image.dart';
import 'package:ezycart/common/widgets/texts/e_brand_title_with_verified_icon.dart';
import 'package:ezycart/common/widgets/texts/product_price_text.dart';
import 'package:ezycart/common/widgets/texts/product_title_text.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/enums.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EProductMetaData extends StatelessWidget {
  const EProductMetaData({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final darkMode = EHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price & Sale Price
        Row(
          children: [
            // Sale Tag
            if (product.salePrice != null)
              ERoundedContainer(
                radius: ESizes.sm,
                backgroundColor: EColors.secondary.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: ESizes.sm,
                  vertical: ESizes.xs,
                ),
                child: Text(
                  '${((product.price - product.salePrice!) / product.price * 100).round()}%',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.apply(color: EColors.black),
                ),
              ),
            if (product.salePrice != null)
              const SizedBox(width: ESizes.spaceBtwItems),

            // Price
            if (product.salePrice != null)
              Text(
                '\$${product.price}',
                style: Theme.of(context).textTheme.titleSmall!.apply(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            if (product.salePrice != null)
              const SizedBox(width: ESizes.spaceBtwItems),
            EProductPriceText(
              price: product.salePrice != null
                  ? product.salePrice.toString()
                  : product.price.toString(),
              isLarge: true,
            ),
          ],
        ),
        const SizedBox(height: ESizes.spaceBtwItems / 1.5),

        // Title
        EProductTitleText(title: product.title),
        const SizedBox(height: ESizes.spaceBtwItems / 1.5),

        // Stock Status
        Row(
          children: [
            const EProductTitleText(title: 'Status'),
            const SizedBox(width: ESizes.spaceBtwItems),
            Text(
              product.stock > 0 ? 'In Stock' : 'Out of Stock',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: ESizes.spaceBtwItems / 1.5),

        // Brand
        Row(
          children: [
            ECircularImage(
              image: EImages.shoeIcon,
              width: 32,
              height: 32,
              overlayColor: darkMode ? EColors.white : EColors.black,
            ),
            EBrandTitleWithVerifiedIcon(
              title: product.brand?.name ?? '',
              brandTextSize: TextSize.large,
            ),
          ],
        ),
      ],
    );
  }
}
