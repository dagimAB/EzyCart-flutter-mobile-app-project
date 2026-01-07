import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/features/admin/controllers/admin_order_controller.dart';
import 'package:ezycart/features/admin/screens/orders/admin_order_details.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminOrderController());
    final dark = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: EAppBar(
        title: Text(
          'Manage All Orders',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.allOrders.isEmpty) {
            return const Center(child: Text('No Orders Found'));
          }

          return ListView.separated(
            shrinkWrap: true,
            itemCount: controller.allOrders.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: ESizes.spaceBtwItems),
            itemBuilder: (_, index) {
              final order = controller.allOrders[index];
              return GestureDetector(
                onTap: () =>
                    Get.to(() => AdminOrderDetailsScreen(order: order)),
                child: ERoundedContainer(
                  showBorder: true,
                  padding: const EdgeInsets.all(ESizes.md),
                  backgroundColor: dark ? EColors.dark : EColors.light,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row 1
                      Row(
                        children: [
                          const Icon(Iconsax.ship),
                          const SizedBox(width: ESizes.spaceBtwItems / 2),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.status.name.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .apply(
                                        color: EColors.primary,
                                        fontWeightDelta: 1,
                                      ),
                                ),
                                Text(
                                  order.formattedOrderDate,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.to(
                              () => AdminOrderDetailsScreen(order: order),
                            ),
                            icon: const Icon(
                              Iconsax.arrow_right_34,
                              size: ESizes.iconSm,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: ESizes.spaceBtwItems),

                      // Row 2
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Iconsax.tag),
                                const SizedBox(width: ESizes.spaceBtwItems / 2),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order ID',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      Text(
                                        order.id,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Iconsax.calendar),
                                const SizedBox(width: ESizes.spaceBtwItems / 2),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                      Text(
                                        '\$${order.totalAmount.toStringAsFixed(2)}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
