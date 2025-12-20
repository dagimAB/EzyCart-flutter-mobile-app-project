import 'package:ezycart/data/repositories/product/product_repository.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:get/get.dart';

class ESearchController extends GetxController {
  static ESearchController get instance => Get.find();

  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final productRepository = ProductRepository.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    try {
      final products = await productRepository.getAllProducts();
      allProducts.assignAll(products);
    } catch (e) {
      // Handle error
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    final filteredProducts = allProducts.where((product) {
      return product.title.toLowerCase().contains(lowerCaseQuery);
    }).toList();

    searchResults.assignAll(filteredProducts);
  }
}
