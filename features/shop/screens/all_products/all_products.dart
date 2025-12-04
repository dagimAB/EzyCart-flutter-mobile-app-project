import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/layouts/grid_layout.dart';
import 'package:ezycart/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EAppBar(
        title: Text('Popular Products'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: EGridLayout(
            itemCount: 8,
            itemBuilder: (_, index) => const EProductCardVertical(),
          ),
        ),
      ),
    );
  }
}
