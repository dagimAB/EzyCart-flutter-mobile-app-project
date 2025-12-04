import 'package:carousel_slider/carousel_slider.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:ezycart/common/widgets/images/e_rounded_image.dart';
import 'package:ezycart/features/shop/controllers/home_controller.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EPromoSlider extends StatelessWidget {
  const EPromoSlider({super.key, required this.banners});

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
          ),
          items: banners
              .map((banner) => ERoundedImage(imageUrl: banner))
              .toList(),
        ),
        const SizedBox(height: ESizes.spaceBtwItems),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++)
                  ECircularContainer(
                    width: 20,
                    height: 4,
                    backgroundColor: controller.carousalCurrentIndex.value == i
                        ? EColors.primary
                        : EColors.grey,
                    margin: const EdgeInsets.only(
                      right: ESizes.spaceBtwItems / 2,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
