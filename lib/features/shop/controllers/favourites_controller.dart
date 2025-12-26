import 'dart:convert';
import 'package:ezycart/data/repositories/product/product_repository.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavouritesController extends GetxController {
  static FavouritesController get instance => Get.find();

  /// Variables
  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initFavorites();
  }

  // Method to initialize favorites by reading from storage
  void initFavorites() {
    final json = GetStorage().read('favorites');
    if (json != null) {
      try {
        // Check if json is already a Map (GetStorage sometimes stores it as object)
        if (json is Map) {
          favorites.assignAll(
            json.map((key, value) => MapEntry(key.toString(), value as bool)),
          );
        } else if (json is String) {
          final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
          favorites.assignAll(
            storedFavorites.map((key, value) => MapEntry(key, value as bool)),
          );
        }
      } catch (e) {
        // If storage is corrupted, clear it to prevent crashes
        GetStorage().remove('favorites');
      }
    }
  }

  bool isFavorite(String productId) {
    return favorites[productId] ?? false;
  }

  void toggleFavoriteProduct(String productId) {
    if (productId.isEmpty) return;

    if (!favorites.containsKey(productId)) {
      favorites[productId] = true;
      saveFavoritesToStorage();
      ELoaders.customToast(message: 'Product has been added to the Wishlist.');
    } else {
      favorites.remove(productId);
      saveFavoritesToStorage();
      ELoaders.customToast(
        message: 'Product has been removed from the Wishlist.',
      );
    }
    favorites.refresh();
  }

  void saveFavoritesToStorage() {
    if (favorites.isEmpty) {
      GetStorage().remove('favorites');
    } else {
      final encodedFavorites = jsonEncode(favorites);
      GetStorage().write('favorites', encodedFavorites);
    }
  }

  Future<List<ProductModel>> favoriteProducts() async {
    if (favorites.isEmpty) return [];
    return await ProductRepository.instance.getFavouriteProducts(
      favorites.keys.toList(),
    );
  }
}
