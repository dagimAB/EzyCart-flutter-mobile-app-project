import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/features/shop/controllers/cart_controller.dart';
import 'package:ezycart/features/shop/controllers/order_controller.dart';
import 'package:ezycart/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:ezycart/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ezycart/features/shop/screens/checkout/widgets/billing_amount_section.dart';
import 'package:ezycart/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:ezycart/utils/helpers/pricing_calculator.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Fix: Ensure CheckoutScreen rebuilds correctly
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final orderController = Get.put(OrderController());
    final subTotal = cartController.totalCartPrice.value;
    final totalPrice = EPricingCalculator.calculateTotalPrice(subTotal, 'US');
    final dark = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              // -- Items in Cart
              const ECartItems(showAddRemoveButtons: false, scrollable: false),
              const SizedBox(height: ESizes.spaceBtwSections),

              // -- Billing Section
              ERoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(ESizes.md),
                backgroundColor: dark ? EColors.black : EColors.white,
                child: const Column(
                  children: [
                    // Pricing
                    EBillingAmountSection(),
                    SizedBox(height: ESizes.spaceBtwItems),

                    // Divider
                    Divider(),
                    SizedBox(height: ESizes.spaceBtwItems),

                    // Payment Methods
                    EBillingPaymentSection(),
                    SizedBox(height: ESizes.spaceBtwItems),

                    // Address
                    EBillingAddressSection(),
                  ],
                ),
              ),
            ],
          ),
        ),yyyyy
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: ElevatedButton(
          onPressed: subTotal > 0
              ? () => orderController.processOrder(totalPrice)
              : () => ELoaders.warningSnackBar(
                  title: 'Empty Cart',
                  message: 'Add items in the cart in order to proceed.',
                ),
          child: Text('Checkout \$$totalPrice'),
        ),
      ),
    );
  }
}
