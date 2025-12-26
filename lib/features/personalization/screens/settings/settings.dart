import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:ezycart/common/widgets/list_tiles/settings_menu_tile.dart';
import 'package:ezycart/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/features/personalization/controllers/user_controller.dart';
import 'package:ezycart/features/personalization/screens/address/address.dart';
import 'package:ezycart/features/personalization/screens/profile/profile.dart';
import 'package:ezycart/features/shop/screens/cart/cart.dart';
import 'package:ezycart/features/shop/screens/order/order.dart';
import 'package:ezycart/features/shop/screens/product/add_product.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // -- Header
            EPrimaryHeaderContainer(
              child: Column(
                children: [
                  // AppBar
                  EAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: EColors.white),
                    ),
                  ),

                  // User Profile Card
                  Obx(
                    () => EUserProfileTile(
                      title: controller.user.value.fullName,
                      subtitle: controller.user.value.email,
                      imageUrl: controller.user.value.profilePicture,
                      onPressed: () => Get.to(() => const ProfileScreen()),
                    ),
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),
                ],
              ),
            ),

            // -- Body
            Padding(
              padding: const EdgeInsets.all(ESizes.defaultSpace),
              child: Column(
                children: [
                  // -- Account Settings
                  const ESectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(height: ESizes.spaceBtwItems),

                  ESettingsMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'My Addresses',
                    subTitle: 'Set shopping delivery address',
                    onTap: () => Get.to(() => const UserAddressScreen()),
                  ),
                  ESettingsMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'My Cart',
                    subTitle: 'Add, remove products and move to checkout',
                    onTap: () => Get.to(() => const CartScreen()),
                  ),
                  ESettingsMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'My Orders',
                    subTitle: 'In-progress and Completed Orders',
                    onTap: () => Get.to(() => const OrderScreen()),
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),

                  // -- Admin Panel
                  Obx(
                    () => controller.isAdmin
                        ? Column(
                            children: [
                              const ESectionHeading(
                                title: 'Admin Panel',
                                showActionButton: false,
                              ),
                              const SizedBox(height: ESizes.spaceBtwItems),
                              ESettingsMenuTile(
                                icon: Iconsax.add_circle,
                                title: 'Add New Product',
                                subTitle: 'Create and upload new products',
                                onTap: () =>
                                    Get.to(() => const AddProductScreen()),
                              ),
                              const SizedBox(height: ESizes.spaceBtwSections),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          AuthenticationRepository.instance.confirmAndLogout(),
                      child: const Text('Logout'),
                    ),
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections * 2.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
