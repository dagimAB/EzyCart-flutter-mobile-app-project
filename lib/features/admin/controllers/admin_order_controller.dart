import 'package:ezycart/data/repositories/order/order_repository.dart';
import 'package:ezycart/features/shop/models/order_model.dart';
import 'package:ezycart/utils/constants/enums.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:get/get.dart';

class AdminOrderController extends GetxController {
  static AdminOrderController get instance => Get.find();

  final orderRepository = Get.put(OrderRepository());
  final allOrders = <OrderModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    fetchAllOrders();
    super.onInit();
  }

  Future<void> fetchAllOrders() async {
    try {
      isLoading.value = true;
      final orders = await orderRepository.getAllOrders();
      // Sort by date descending
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      allOrders.assignAll(orders);
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(
    OrderModel order,
    OrderStatus newStatus,
  ) async {
    try {
      ELoaders.customToast(message: 'Updating Order Status...');
      await orderRepository.updateOrderStatus(
        order.id,
        order.userId,
        newStatus.toString(),
      );

      // Update local list
      final index = allOrders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        // Create new instance with updated status since OrderModel is immutable
        // Note: You might need to update OrderModel to have copyWith or basic mutable status
        // For now, simpler to re-fetch or assume successful
        fetchAllOrders();
      }

      ELoaders.successSnackBar(
        title: 'Success',
        message: 'Order Status Updated',
      );
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
