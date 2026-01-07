import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/features/shop/models/order_model.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /* ---------------------------- FUNCTIONS --------------------------------- */
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) {
        throw 'Unable to find user information. Try login again.';
      }

      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .get();
      return result.docs
          .map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching Order Information. Try again later';
    }
  }

  Future<void> saveOrder(OrderModel order, String userId) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .add(order.toJson());
    } catch (e) {
      throw 'Something went wrong while saving Order Information. Try again later';
    }
  }

  /// Fetch ALL orders for Admin using Collection Group Query
  Future<List<OrderModel>> getAllOrders() async {
    try {
      final result = await _db.collectionGroup('Orders').get();
      return result.docs
          .map((documentSnapshot) => OrderModel.fromSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching all orders. Try again later';
    }
  }

  /// Update Order Status
  Future<void> updateOrderStatus(
    String orderId,
    String userId,
    String status,
  ) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .doc(orderId)
          .update({'status': status});
    } catch (e) {
      throw 'Error updating: $e';
    }
  }
}
