import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/personalization/controllers/address_controller.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EBillingAddressSection extends StatelessWidget {
  const EBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ESectionHeading(
          title: 'Shipping Address',
          buttonTitle: 'Change',
          onPressed: () => addressController.selectNewAddressPopup(context),
        ),
        Obx(
          () => addressController.selectedAddress.value.id.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addressController.selectedAddress.value.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: ESizes.spaceBtwItems / 2),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.grey, size: 16),
                        const SizedBox(width: ESizes.spaceBtwItems),
                        Text(
                          addressController.selectedAddress.value.phoneNumber,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: ESizes.spaceBtwItems / 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_history,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: ESizes.spaceBtwItems),
                        Expanded(
                          child: Text(
                            addressController.selectedAddress.value.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  'Select Address',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ),
      ],
    );
  }
}
