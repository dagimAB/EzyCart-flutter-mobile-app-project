import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/features/personalization/controllers/address_controller.dart';
import 'package:ezycart/features/personalization/screens/address/add_new_address.dart';
import 'package:ezycart/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: EColors.primary,
        onPressed: () => Get.to(
          () => const AddNewAddressScreen(),
        ), // Navigate to Add New Address Screen
        child: const Icon(Iconsax.add, color: EColors.white),
      ),
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Addresses',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Obx(
            () => FutureBuilder(
              // Use key to trigger refresh
              key: Key(controller.refreshData.value.toString()),
              future: controller.getAllUserAddresses(),
              builder: (context, snapshot) {
                final response = ECloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                );
                if (response != null) return response;

                final addresses = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  itemBuilder: (_, index) => ESingleAddress(
                    address: addresses[index],
                    onTap: () => controller.selectAddress(addresses[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
