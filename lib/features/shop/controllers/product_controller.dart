import 'package:ezycart/data/repositories/product/product_repository.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:get/get.dart';
import 'package:ezycart/utils/errors/error_handler.dart';

class ProductController extends GetxController {
  // Ensure a controller is available even if HomeScreen hasn't been built
  static ProductController get instance => Get.isRegistered<ProductController>()
      ? Get.find()
      : Get.put(ProductController());

  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  void fetchFeaturedProducts() async {
    try {
      // Show loader while loading products
      isLoading.value = true;

      // Fetch Products
      final products = await productRepository.getFeaturedProducts();

      // Assign Products
      featuredProducts.assignAll(products);
    } catch (e) {
      ErrorHandler.showError(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage:
            'Failed to load featured products. Check your internet connection and try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      // Fetch Products
      final products = await productRepository.getAllFeaturedProducts();
      return products;
    } catch (e) {
      ErrorHandler.showError(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage: 'Failed to retrieve featured products.',
      );
      return [];
    }
  }

  Future<List<ProductModel>> fetchProductsByCategoryId(
    String categoryId,
  ) async {
    try {
      final products = await productRepository.getProductsByCategoryId(
        categoryId,
      );
      return products;
    } catch (e) {
      ErrorHandler.showError(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage: 'Failed to retrieve products for this category.',
      );
      return [];
    }
  }
}
