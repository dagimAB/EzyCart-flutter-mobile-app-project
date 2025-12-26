import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ezycart/features/shop/controllers/product_controller.dart';
import 'package:ezycart/features/shop/models/category_model.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ECategoryTab extends StatelessWidget {
  const ECategoryTab({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              // -- Brands (Removed as per request)

              // -- Products
              // const ESectionHeading(
              //   title: 'You might like',
              //   showActionButton: true,
              // ),
              const SizedBox(height: ESizes.spaceBtwItems),

              FutureBuilder(
                future: controller.fetchProductsByCategoryId(category.id),
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
              const SizedBox(height: ESizes.spaceBtwSections),
            ],
          ),
        ),
      ],
    );
  }
}
