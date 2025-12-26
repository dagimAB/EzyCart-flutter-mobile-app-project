import 'dart:io';
import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/features/shop/controllers/add_product_controller.dart';
import 'package:ezycart/features/shop/controllers/category_controller.dart';
import 'package:ezycart/features/shop/models/category_model.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/validators/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductController());
    final categoryController = Get.put(CategoryController());

    return Scaffold(
      appBar: const EAppBar(
        title: Text('Add New Product'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Form(
            key: controller.addProductFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- Image Picker
                GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Obx(
                    () => Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: controller.selectedImage.value != null
                          ? (kIsWeb
                                ? Image.network(
                                    controller.selectedImage.value!.path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(controller.selectedImage.value!.path),
                                    fit: BoxFit.cover,
                                  ))
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text('Tap to select image'),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtwSections),

                // -- Title
                TextFormField(
                  controller: controller.title,
                  validator: (value) =>
                      EValidator.validateEmptyText('Title', value),
                  decoration: const InputDecoration(
                    labelText: 'Product Title',
                    prefixIcon: Icon(Iconsax.box),
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtwInputFields),

                // -- Price & Sale Price
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.price,
                        validator: (value) =>
                            EValidator.validateEmptyText('Price', value),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          prefixIcon: Icon(Iconsax.money),
                        ),
                      ),
                    ),
                    const SizedBox(width: ESizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.salePrice,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Sale Price',
                          prefixIcon: Icon(Iconsax.discount_shape),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ESizes.spaceBtwInputFields),

                // -- Stock & Brand
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.stock,
                        validator: (value) =>
                            EValidator.validateEmptyText('Stock', value),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stock',
                          prefixIcon: Icon(Iconsax.sort),
                        ),
                      ),
                    ),
                    const SizedBox(width: ESizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.brand,
                        validator: (value) =>
                            EValidator.validateEmptyText('Brand', value),
                        decoration: const InputDecoration(
                          labelText: 'Brand',
                          prefixIcon: Icon(Iconsax.tag),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ESizes.spaceBtwInputFields),

                // -- Category Dropdown
                Obx(() {
                  if (categoryController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (categoryController.allCategories.isEmpty) {
                    return Center(
                      child: TextButton(
                        onPressed: () => categoryController.fetchCategories(),
                        child: const Text('No Categories Found. Tap to Retry.'),
                      ),
                    );
                  }

                  return DropdownButtonFormField<CategoryModel>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Iconsax.category),
                    ),
                    initialValue: controller.selectedCategory.value,
                    onChanged: (newValue) =>
                        controller.selectedCategory.value = newValue,
                    items: categoryController.allCategories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  );
                }),
                const SizedBox(height: ESizes.spaceBtwInputFields),

                // -- Description
                TextFormField(
                  controller: controller.description,
                  validator: (value) =>
                      EValidator.validateEmptyText('Description', value),
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Iconsax.document_text),
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtwInputFields),

                // -- Featured Checkbox
                Obx(
                  () => CheckboxListTile(
                    title: const Text('Featured Product'),
                    value: controller.isFeatured.value,
                    onChanged: (value) =>
                        controller.isFeatured.value = value ?? false,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtwSections),

                // -- Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.saveProduct(),
                    child: const Text('Save Product'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
