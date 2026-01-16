import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/personalization/controllers/user_controller.dart';
import 'package:ezycart/features/shop/controllers/product_controller.dart';
import 'package:ezycart/data/repositories/product/product_repository.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:ezycart/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:ezycart/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:ezycart/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/popups/full_screen_loader.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/errors/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final productController = ProductController.instance;

    return Scaffold(
      appBar: EAppBar(
        title: Text(product.title),
        showBackArrow: true,
        actions: [
          Obx(() {
            if (!userController.isAdmin) return const SizedBox.shrink();
            return IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'Delete Product',
                  middleText:
                      'Are you sure you want to delete this product? This action cannot be undone and deletes the database record.',
                  textConfirm: 'Delete',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    Get.back(); // close dialog
                    try {
                      EFullScreenLoader.openLoadingDialog(
                        'Deleting Product...',
                        EImages.onBoardingImage1,
                      );

                      // Delete from Firestore
                      await ProductRepository.instance.deleteProduct(
                        product.id,
                      );

                      // Update any in-memory lists (e.g., featured products)
                      productController.featuredProducts.removeWhere(
                        (p) => p.id == product.id,
                      );

                      EFullScreenLoader.stopLoading();

                      ELoaders.successSnackBar(
                        title: 'Deleted',
                        message: 'Product deleted successfully.',
                      );

                      Get.back(); // Close details screen
                    } catch (e) {
                      EFullScreenLoader.stopLoading();
                      ErrorHandler.showError(error: e, title: 'Delete Failed');
                    }
                  },
                );
              },
              icon: const Icon(Icons.delete),
            );
          }),
        ],
      ),
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
