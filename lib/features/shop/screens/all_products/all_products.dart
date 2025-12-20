import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ezycart/features/shop/controllers/product_controller.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    return Scaffold(
      appBar: const EAppBar(
        title: Text('Popular Products'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: FutureBuilder(
            future: controller.fetchAllFeaturedProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const Center(child: Text('No Data Found!'));
              }

              final products = snapshot.data as List<ProductModel>;

              return EGridLayout(
                itemCount: products.length,
                itemBuilder: (_, index) =>
                    EProductCardVertical(product: products[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
