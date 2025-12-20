import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/shop/models/payment_method_model.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Fix: Ensure library is loaded correctly
class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final Rx<PaymentMethodModel> selectedPaymentMethod =
      PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(
      name: 'Chapa',
      image: EImages.chapa,
    );
    super.onInit();
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(ESizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ESectionHeading(
                title: 'Select Payment Method',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),
              EPaymentTile(
                paymentMethod: PaymentMethodModel(
                  name: 'Chapa',
                  image: EImages.chapa,
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

class EPaymentTile extends StatelessWidget {
  const EPaymentTile({super.key, required this.paymentMethod});

  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        controller.selectedPaymentMethod.value = paymentMethod;
        Get.back();
      },
      leading: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ESizes.sm),
        ),
        padding: const EdgeInsets.all(ESizes.sm),
        child: Image.asset(
          paymentMethod.image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.network(
            'https://raw.githubusercontent.com/chapa-et/chapa-flutter/main/assets/images/chapa-logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(
                paymentMethod.name,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ),
      ),
      title: Text(paymentMethod.name),
      trailing: Obx(
        () => Icon(
          controller.selectedPaymentMethod.value.name == paymentMethod.name
              ? Icons.check_circle
              : null,
        ),
      ),
    );
  }
}
