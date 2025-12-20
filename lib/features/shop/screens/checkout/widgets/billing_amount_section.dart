import 'package:ezycart/features/shop/controllers/cart_controller.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/pricing_calculator.dart';
import 'package:flutter/material.dart';

class EBillingAmountSection extends StatelessWidget {
  const EBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    final subTotal = controller.totalCartPrice.value;
    final shippingFee = EPricingCalculator.calculateShippingCost(
      subTotal,
      'US',
    );
    final taxFee = EPricingCalculator.calculateTax(subTotal, 'US');
    final totalPrice = EPricingCalculator.calculateTotalPrice(subTotal, 'US');

    return Column(
      children: [
        // SubTotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
            Text('\$$subTotal', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: ESizes.spaceBtwItems / 2),

        // Shipping Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shipping Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '\$$shippingFee',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: ESizes.spaceBtwItems / 2),

        // Tax Fee
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tax Fee', style: Theme.of(context).textTheme.bodyMedium),
            Text('\$$taxFee', style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
        const SizedBox(height: ESizes.spaceBtwItems / 2),

        // Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Total', style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '\$$totalPrice',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
