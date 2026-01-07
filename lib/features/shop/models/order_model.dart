import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezycart/features/personalization/models/address_model.dart';
import 'package:ezycart/features/shop/models/cart_item_model.dart';
import 'package:ezycart/utils/constants/enums.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    this.address,
    this.deliveryDate,
  });

  String get formattedOrderDate => EHelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? EHelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
      ? 'Shipment on the way'
      : 'Processing';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    // Robustly get userId from the Firestore path logic to ensure Updates work
    // Path: Users/{userId}/Orders/{orderId}
    String derivedUserId = data['userId'] ?? '';
    if (snapshot.reference.parent.parent != null) {
      derivedUserId = snapshot.reference.parent.parent!.id;
    }

    return OrderModel(
      id: snapshot.id,
      userId: derivedUserId,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == data['status'],
        orElse: () => OrderStatus.pending,
      ),
      totalAmount: data['totalAmount'] as double,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] as String,
      address: AddressModel.fromMap(data['address'] as Map<String, dynamic>),
      deliveryDate: data['deliveryDate'] == null
          ? null
          : (data['deliveryDate'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
