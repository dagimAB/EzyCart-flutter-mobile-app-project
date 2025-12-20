import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:ezycart/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:ezycart/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:ezycart/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: EBottomAddToCart(product: product),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1 - Product Image Slider
            EProductImageSlider(imageUrl: product.image),

            // 2 - Product Details
            Padding(
              padding: const EdgeInsets.only(
                right: ESizes.defaultSpace,
                left: ESizes.defaultSpace,
                bottom: ESizes.defaultSpace,
              ),
              child: Column(
                children: [
                  // - Rating & Share Button
                  const ERatingShareWidget(),

                  // - Price, Title, Stock, & Brand
                  EProductMetaData(product: product),
                  const SizedBox(height: ESizes.spaceBtwSections),

                  // - Description
                  const ESectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  const SizedBox(height: ESizes.spaceBtwItems),
                  ReadMoreText(
                    product.description ?? 'No description available.',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                    lessStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
