import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/features/personalization/controllers/address_controller.dart';
import 'package:ezycart/features/shop/controllers/category_controller.dart';
import 'package:ezycart/features/shop/controllers/favourites_controller.dart';
import 'package:ezycart/navigation_menu.dart';
import 'package:get/get.dart';
import 'package:ezycart/features/personalization/controllers/theme_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationRepository());
    Get.put(AddressController());
    Get.put(CategoryController());
    Get.put(FavouritesController());

    // Ensure NavigationController is available app-wide so widgets like
    // Wishlist can safely call Get.find<NavigationController>()
    if (!Get.isRegistered<NavigationController>()) {
      Get.put(NavigationController());
    }

    // Theme controller for user-selected app theme
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController());
    }
  }
}
