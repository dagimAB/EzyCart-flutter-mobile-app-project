import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/brands/brand_card.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EAppBar(title: Text('Nike'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              // Brand Detail
              const EBrandCard(showBorder: true),
              const SizedBox(height: ESizes.spaceBtwSections),

              EGridLayout(
                itemCount: 4,
                itemBuilder: (_, index) => const EProductCardVertical(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
