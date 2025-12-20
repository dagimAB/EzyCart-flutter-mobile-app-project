import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/shop/controllers/checkout_controller.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EBillingPaymentSection extends StatelessWidget {
  const EBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final dark = EHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        const ESectionHeading(title: 'Payment Method', showActionButton: false),
        const SizedBox(height: ESizes.spaceBtwItems / 2),
        Obx(
          () => Row(
            children: [
              ERoundedContainer(
                width: 60,
                height: 35,
                backgroundColor: dark ? EColors.light : EColors.white,
                padding: const EdgeInsets.all(ESizes.sm),
                child: Image.asset(
                  controller.selectedPaymentMethod.value.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    'https://raw.githubusercontent.com/chapa-et/chapa-flutter/main/assets/images/chapa-logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(
                        controller.selectedPaymentMethod.value.name,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: ESizes.spaceBtwItems / 2),
              Text(
                controller.selectedPaymentMethod.value.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
