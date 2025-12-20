import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/images/e_rounded_image.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ezycart/features/shop/controllers/product_controller.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({
    super.key,
    required this.title,
    required this.categoryId,
  });

  final String title;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    return Scaffold(
      appBar: EAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              // Banner
              const ERoundedImage(
                width: double.infinity,
                imageUrl: EImages.promoBanner1,
                applyImageRadius: true,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              // Products
              FutureBuilder(
                future: controller.fetchProductsByCategoryId(categoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Products Found!'));
                  }

                  final products = snapshot.data as List<ProductModel>;

                  return EGridLayout(
                    itemCount: products.length,
                    itemBuilder: (_, index) =>
                        EProductCardVertical(product: products[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
