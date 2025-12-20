import 'package:ezycart/common/widgets/icons/e_circular_icon.dart';
import 'package:ezycart/features/shop/controllers/favourites_controller.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EFavouriteIcon extends StatelessWidget {
  const EFavouriteIcon({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouritesController());
    return Obx(
      () => ECircularIcon(
        icon: controller.isFavorite(productId) ? Iconsax.heart5 : Iconsax.heart,
        color: controller.isFavorite(productId) ? EColors.error : null,
        onPressed: () => controller.toggleFavoriteProduct(productId),
      ),
    );
  }
}
