import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/features/personalization/controllers/address_controller.dart';
import 'package:ezycart/features/personalization/models/address_model.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ESingleAddress extends StatelessWidget {
  const ESingleAddress({super.key, required this.address, required this.onTap});

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    final dark = EHelperFunctions.isDarkMode(context);

    return Obx(() {
      final selectedAddressId = controller.selectedAddress.value.id;
      final selectedAddress = selectedAddressId == address.id;
      return InkWell(
        onTap: onTap,
        child: ERoundedContainer(
          padding: const EdgeInsets.all(ESizes.md),
          width: double.infinity,
          showBorder: true,
          backgroundColor: selectedAddress
              ? EColors.primary.withValues(alpha: 0.5)
              : Colors.transparent,
          borderColor: selectedAddress
              ? Colors.transparent
              : dark
              ? EColors.darkerGrey
              : EColors.grey,
          margin: const EdgeInsets.only(bottom: ESizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(
                  selectedAddress ? Iconsax.tick_circle5 : null,
                  color: selectedAddress
                      ? dark
                            ? EColors.light
                            : EColors.dark
                      : null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: ESizes.sm / 2),
                  Text(
                    address.formattedPhoneNo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: ESizes.sm / 2),
                  Text(address.toString(), softWrap: true),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
