import 'package:ezycart/common/widgets/success_screen/success_screen.dart';
import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/data/repositories/order/order_repository.dart';
import 'package:ezycart/data/services/chapa_service.dart';
import 'package:ezycart/features/personalization/controllers/address_controller.dart';
import 'package:ezycart/features/shop/controllers/cart_controller.dart';
import 'package:ezycart/features/shop/controllers/checkout_controller.dart';
import 'package:ezycart/features/shop/models/order_model.dart';
import 'package:ezycart/navigation_menu.dart';
import 'package:ezycart/utils/constants/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/popups/full_screen_loader.dart';
import 'package:get/get.dart';
import 'package:ezycart/utils/errors/error_handler.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  /// Variables
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = Get.put(CheckoutController());
  final orderRepository = Get.put(OrderRepository());

  /// Fetch all user specific orders
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      ErrorHandler.showWarning(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage: 'Could not fetch orders. Check your connection.',
      );
      return [];
    }
  }

  /// Add Methods for Order Processing
  void processOrder(double totalAmount) async {
    try {
      // Start Loader
      EFullScreenLoader.openLoadingDialog(
        'Processing your order',
        EImages.pencilAnimation,
      );

      // Get User Id
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) return;

      // Check Payment Method
      final paymentMethod = checkoutController.selectedPaymentMethod.value;

      if (paymentMethod.name == 'Chapa') {
        // Initialize Chapa Payment
        final txRef = ChapaService.generateTxRef();
        final checkoutUrl = await ChapaService.initializeTransaction(
          amount: totalAmount.toString(),
          currency: 'ETB', // Assuming ETB for Chapa
          email:
              AuthenticationRepository.instance.authUser!.email ??
              'customer@example.com',
          firstName: 'Customer', // You might want to get this from user profile
          lastName: 'User',
          txRef: txRef,
          title: 'EzyCart Order',
          description: 'Payment for order $txRef',
        );

        if (checkoutUrl != null) {
          await ChapaService.launchPaymentUrl(checkoutUrl);
          // In a real app, you would verify the payment here or via webhook
          // For now, we proceed to save order
        } else if (kIsWeb) {
          // Web Form Post handled redirection
        } else {
          throw 'Failed to get payment URL';
        }
      }

      // Add Details
      final order = OrderModel(
        // Generate a unique ID for the order
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: 'Chapa',
        address: addressController.selectedAddress.value,
        // Set delivery date as needed
        deliveryDate: DateTime.now().add(const Duration(days: 3)),
        items: cartController.cartItems.toList(),
      );

      // Save the order to Firestore
      await orderRepository.saveOrder(order, userId);

      // Update the cart status
      cartController.clearCart();

      // Show Success Screen
      Get.off(
        () => SuccessScreen(
          image: EImages.orderCompletedAnimation,
          title: 'Payment Success!',
          subtitle: 'Your item will be shipped soon!',
          onPressed: () => Get.offAll(() => const NavigationMenu()),
        ),
      );
    } catch (e) {
      ErrorHandler.showError(
        error: e,
        title: 'Checkout Failed',
        fallbackMessage:
            'Payment or order processing failed. Check your network and payment details and try again.',
      );
    } finally {
      // Remove Loader
      EFullScreenLoader.stopLoading();
    }
  }
}
