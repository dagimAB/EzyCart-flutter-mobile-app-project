import 'package:ezycart/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:ezycart/features/shop/screens/sub_category/sub_categories.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EHomeCategories extends StatelessWidget {
  const EHomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return EVerticalImageText(
            image: EImages.shoeIcon,
            title: "shoes",
            onTap: () => Get.to(() => const SubCategoriesScreen()),
          );
        },
      ),
    );
  }
}
