import 'package:ezycart/features/shop/models/cart_item_model.dart';
import 'package:ezycart/utils/local_storage/storage_utility.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // Variables
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  @override
  void onInit() {
    loadCartItems();
    super.onInit();
  }

  // Add Item in the cart
  void addToCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      // This quantity is already added or updated/removed from the design
      cartItems[index].quantity = item.quantity;
    } else {
      cartItems.add(item);
    }

    updateCart();
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }

    updateCart();
  }

  void removeOneFromCart(CartItemModel item) {
    int index = cartItems.indexWhere(
      (cartItem) =>
          cartItem.productId == item.productId &&
          cartItem.variationId == item.variationId,
    );

    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        // Show dialog before removing
        cartItems[index].quantity == 1
            ? removeFromCartDialog(cartItems[index])
            : cartItems.removeAt(index);
      }
      updateCart();
    }
  }

  void removeFromCartDialog(CartItemModel item) {
    Get.defaultDialog(
      title: 'Remove Product',
      middleText: 'Are you sure you want to remove this product?',
      onConfirm: () {
        // Remove the item from the list
        cartItems.removeWhere(
          (cartItem) =>
              cartItem.productId == item.productId &&
              cartItem.variationId == item.variationId,
        );
        updateCart();
        Get.back();
      },
      onCancel: () => () {},
    );
  }

  // Initialize already added Item's Count in the cart.
  void updateAlreadyAddedProductCount(String productId) {
    // If product has no variations then calculate cartEntries and display total number.
    // Else make default entries to 0 and show cartEntries when variation is selected.
    productQuantityInCart.value = getProductQuantityInCart(productId);
  }

  // This function converts a ProductModel to a CartItemModel and handles the quantity logic
  // For now, we'll assume we are passing a CartItemModel directly or constructing it in the UI
  // In a real app, you'd have a method to convert Product -> CartItem

  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += (item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    noOfCartItems.value = calculatedNoOfItems;
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toJson()).toList();
    ELocalStorage.instance().saveData('cartItems', cartItemStrings);
  }

  void loadCartItems() {
    final cartItemStrings = ELocalStorage.instance().readData<List<dynamic>>(
      'cartItems',
    );
    if (cartItemStrings != null) {
      cartItems.assignAll(
        cartItemStrings.map(
          (item) => CartItemModel.fromJson(item as Map<String, dynamic>),
        ),
      );
      updateCartTotals();
    }
  }

  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems
        .where((item) => item.productId == productId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);
    return foundItem;
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
