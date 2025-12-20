import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/features/personalization/controllers/address_controller.dart';
import 'package:ezycart/features/shop/controllers/category_controller.dart';
import 'package:ezycart/features/shop/controllers/favourites_controller.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationRepository());
    Get.put(AddressController());
    Get.put(CategoryController());
    Get.put(FavouritesController());
  }
}
