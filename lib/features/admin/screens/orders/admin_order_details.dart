import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/common/widgets/products/cart/cart_item.dart';
import 'package:ezycart/features/admin/controllers/admin_order_controller.dart';
import 'package:ezycart/features/shop/models/order_model.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/enums.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOrderDetailsScreen extends StatelessWidget {
  const AdminOrderDetailsScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = AdminOrderController.instance;
    final dark = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: EAppBar(
        title: Text(
          'Order Details',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Status Change Section
              ERoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(ESizes.md),
                backgroundColor: dark ? EColors.dark : EColors.light,
                child: Column(
                  children: [
                    Text(
                      'Update Order Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: ESizes.spaceBtwItems),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<OrderStatus>(
                            decoration: const InputDecoration(
                              labelText: 'Status',
                            ),
                            value: order.status,
                            onChanged: (OrderStatus? newValue) {
                              if (newValue != null) {
                                controller.updateOrderStatus(order, newValue);
                              }
                            },
                            items: OrderStatus.values.map((OrderStatus status) {
                              return DropdownMenuItem<OrderStatus>(
                                value: status,
                                child: Text(status.name.toUpperCase()),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              // -- Order Items
              Text('Items', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: ESizes.spaceBtwItems),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: ESizes.spaceBtwItems),
                itemBuilder: (_, index) {
                  final item = order.items[index];
                  return ECartItem(cartItem: item);
                },
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              // -- Customer Info (If available in OrderModel, otherwise simplistic)
              Text(
                'Shipping Address',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),
              ERoundedContainer(
                showBorder: true,
                width: double.infinity,
                padding: const EdgeInsets.all(ESizes.md),
                backgroundColor: dark ? EColors.dark : EColors.light,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.address != null) ...[
                      Text(
                        order.address!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: ESizes.spaceBtwItems / 2),
                      Text(
                        order.address!.phoneNumber,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: ESizes.spaceBtwItems / 2),
                      Text(
                        order.address!.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ] else
                      const Text('No Address Data'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
