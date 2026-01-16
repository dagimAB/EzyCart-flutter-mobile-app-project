import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezycart/features/shop/models/brand_model.dart';
import 'package:ezycart/features/shop/models/category_model.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/services/cloudinary_service.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/popups/full_screen_loader.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ezycart/utils/errors/error_handler.dart';

class AddProductController extends GetxController {
  static AddProductController get instance => Get.find();

  // Variables
  final title = TextEditingController();
  final price = TextEditingController();
  final salePrice = TextEditingController();
  final stock = TextEditingController();
  final description = TextEditingController();
  final brand = TextEditingController();

  final isLoading = false.obs;
  final isFeatured = false.obs;
  final selectedCategory = Rx<CategoryModel?>(null);
  final selectedImage = Rx<XFile?>(null); // Changed to XFile for Web support

  GlobalKey<FormState> addProductFormKey = GlobalKey<FormState>();

  // Pick Image
  void pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image != null) {
        selectedImage.value = image;
      }
    } catch (e) {
      ErrorHandler.showError(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage:
            'Failed to pick image. Please check your permissions and try again.',
      );
    }
  }

  // Save Product
  void saveProduct() async {
    try {
      // Start Loading
      EFullScreenLoader.openLoadingDialog(
        'Saving Product...',
        EImages.onBoardingImage1,
      );

      // Form Validation
      if (!addProductFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      if (selectedCategory.value == null) {
        EFullScreenLoader.stopLoading();
        ELoaders.warningSnackBar(
          title: 'Select Category',
          message: 'Please select a category for the product.',
        );
        return;
      }

      // Upload Image if selected
      String imageUrl = '';
      if (selectedImage.value != null) {
        final uploaded = await CloudinaryService.uploadImage(
          selectedImage.value!.path,
          file: selectedImage.value,
        );
        imageUrl = uploaded ?? '';
      }

      if (imageUrl.isEmpty) {
        imageUrl = EImages.productImage1; // Default placeholder
      }

      // Create Product Model
      final newProduct = ProductModel(
        id: '', // Firestore will generate ID if we use .add(), or we generate one
        title: title.text.trim(),
        stock: int.parse(stock.text.trim()),
        price: double.parse(price.text.trim()),
        salePrice: salePrice.text.isNotEmpty
            ? double.parse(salePrice.text.trim())
            : 0.0,
        thumbnail: imageUrl,
        description: description.text.trim(),
        productType: 'Single',
        categoryId: selectedCategory.value!.id,
        brand: BrandModel(
          id: '',
          name: brand.text.trim(),
          image: EImages.google,
        ), // Simple brand
        isFeatured: isFeatured.value,
        images: [imageUrl], // Add thumbnail to images list
        date: DateTime.now(),
      );

      // Save to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('Products')
          .add(newProduct.toJson());

      // Update ID in the document
      await docRef.update({'Id': docRef.id});

      // Stop Loading
      EFullScreenLoader.stopLoading();

      // Show Success Message
      ELoaders.successSnackBar(
        title: 'Success',
        message: 'Product has been added successfully.',
      );

      // Reset Form
      resetForm();

      // Go back
      Get.back();
    } catch (e) {
      EFullScreenLoader.stopLoading();
      ErrorHandler.showError(error: e, title: 'Oh Snap!');
    }
  }

  void resetForm() {
    title.clear();
    price.clear();
    salePrice.clear();
    stock.clear();
    description.clear();
    brand.clear();
    selectedCategory.value = null;
    selectedImage.value = null;
    isFeatured.value = false;
  }
}
