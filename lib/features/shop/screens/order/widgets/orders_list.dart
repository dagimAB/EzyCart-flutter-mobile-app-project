import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/features/shop/controllers/order_controller.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/cloud_helper_functions.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EOrderListItems extends StatelessWidget {
  const EOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    final dark = EHelperFunctions.isDarkMode(context);

    return FutureBuilder(
      future: controller.fetchUserOrders(),
      builder: (_, snapshot) {
        final emptyWidget = ECloudHelperFunctions.checkMultiRecordState(
          snapshot: snapshot,
          nothingFound: const Center(child: Text('No orders found!')),
          error: const Center(child: Text('Something went wrong!')),
        );
        if (emptyWidget != null) return emptyWidget;

        final orders = snapshot.data!;
        return ListView.separated(
          shrinkWrap: true,
          itemCount: orders.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: ESizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final order = orders[index];
            return ERoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(ESizes.md),
              backgroundColor: dark ? EColors.dark : EColors.light,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // -- Row 1
                  Row(
                    children: [
                      // 1 - Icon
                      const Icon(Iconsax.ship),
                      const SizedBox(width: ESizes.spaceBtwItems / 2),

                      // 2 - Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderStatusText,
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .apply(
                                    color: EColors.primary,
                                    fontWeightDelta: 1,
                                  ),
                            ),
                            Text(
                              order.formattedOrderDate,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),

                      // 3 - Icon
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Iconsax.arrow_right_34,
                          size: ESizes.iconSm,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ESizes.spaceBtwItems),

                  // -- Row 2
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            // 1 - Icon
                            const Icon(Iconsax.tag),
                            const SizedBox(width: ESizes.spaceBtwItems / 2),

                            // 2 - Status & Date
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                  Text(
                                    '[#${order.id.substring(0, 6)}]',
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
                            // 1 - Icon
                            const Icon(Iconsax.calendar),
                            const SizedBox(width: ESizes.spaceBtwItems / 2),

                            // 2 - Status & Date
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shipping Date',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                  Text(
                                    order.formattedDeliveryDate,
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
            );
          },
        );
      },
    );
  }
}
