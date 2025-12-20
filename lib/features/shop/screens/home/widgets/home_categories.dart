import 'package:ezycart/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:ezycart/features/shop/controllers/category_controller.dart';
import 'package:ezycart/features/shop/screens/sub_category/sub_categories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EHomeCategories extends StatelessWidget {
  const EHomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    return Obx(() {
      if (categoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (categoryController.featuredCategories.isEmpty) {
        return Center(
          child: Text(
            'No Data Found!',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.apply(color: Colors.white),
          ),
        );
      }

      return SizedBox(
        height: 120,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categoryController.featuredCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final category = categoryController.featuredCategories[index];
            return EVerticalImageText(
              image: category.image,
              title: category.name,
              isNetworkImage: category.image.startsWith('http'),
              onTap: () => Get.to(
                () => SubCategoriesScreen(
                  title: category.name,
                  categoryId: category.id,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
