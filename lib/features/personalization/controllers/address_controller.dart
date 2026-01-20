import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/data/repositories/address/address_repository.dart';
import 'package:ezycart/features/personalization/models/address_model.dart';
import 'package:ezycart/features/personalization/screens/address/add_new_address.dart';
import 'package:ezycart/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/cloud_helper_functions.dart';
import 'package:ezycart/utils/popups/full_screen_loader.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:ezycart/utils/errors/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final street = TextEditingController();
  final postalCode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());

  /// Fetch all user specific addresses
  Future<List<AddressModel>> getAllUserAddresses() async {
    try {
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere(
        (element) => element.selectedAddress,
        orElse: () => AddressModel.empty(),
      );
      return addresses;
    } catch (e) {
      ErrorHandler.showError(
        error: e,
        title: 'Address not found',
        fallbackMessage:
            'Could not load addresses. Please check your connection.',
      );
      return [];
    }
  }

  Future<void> selectAddress(AddressModel newSelectedAddress) async {
    try {
      // Clear the "selected" field
      if (selectedAddress.value.id.isNotEmpty) {
        await addressRepository.updateSelectedField(
          selectedAddress.value.id,
          false,
        );
      }

      // Assign selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      // Set the "selected" field to true for the newly selected address
      await addressRepository.updateSelectedField(
        selectedAddress.value.id,
        true,
      );
    } catch (e) {
      ErrorHandler.showError(
        error: e,
        title: 'Selection Failed',
        fallbackMessage: 'Could not select address. Please try again.',
      );
    }
  }

  /// Add new Address
  Future addNewAddresses() async {
    try {
      // Start Loading
      EFullScreenLoader.openLoadingDialog(
        'Storing Address...',
        EImages.processingGear,
      );

      // Form Validation
      if (!addressFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Save Address Data
      final address = AddressModel(
        id: '',
        name: name.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        street: street.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        postalCode: postalCode.text.trim(),
        country: country.text.trim(),
        selectedAddress: true,
      );

      final id = await addressRepository.addAddress(address);

      // Update Selected Address status
      address.id = id;
      await selectAddress(address);

      // Remove Loader
      EFullScreenLoader.stopLoading();

      // Show Success Message
      ELoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your address has been saved successfully.',
      );

      // Refresh Addresses Data
      refreshData.toggle();

      // Reset fields
      resetFormFields();

      // Redirect
      Navigator.of(Get.context!).pop();
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();
      ErrorHandler.showError(
        error: e,
        title: 'Address save failed',
        fallbackMessage: 'Could not save address. Please try again.',
      );
    }
  }

  /// Function to reset form fields
  void resetFormFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }

  /// Show Addresses ModalBottomSheet at Checkout
  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(ESizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ESectionHeading(
              title: 'Select Address',
              showActionButton: false,
            ),
            const SizedBox(height: ESizes.spaceBtwSections),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: getAllUserAddresses(),
                      builder: (_, snapshot) {
                        final response =
                            ECloudHelperFunctions.checkMultiRecordState(
                              snapshot: snapshot,
                            );
                        if (response != null) return response;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => ESingleAddress(
                            address: snapshot.data![index],
                            onTap: () async {
                              await selectAddress(snapshot.data![index]);
                              Get.back();
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: ESizes.defaultSpace * 2),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Get.to(() => const AddNewAddressScreen()),
                        child: const Text('Add new address'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
