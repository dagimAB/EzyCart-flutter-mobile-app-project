import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/images/e_circular_image.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/personalization/controllers/user_controller.dart';
import 'package:ezycart/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: const EAppBar(showBackArrow: true, title: Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              // Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty
                          ? networkImage
                          : EImages.user;
                      return controller.imageUploading.value
                          ? const CircularProgressIndicator()
                          : ECircularImage(
                              image: image,
                              isNetworkImage: networkImage.isNotEmpty,
                              width: 80,
                              height: 80,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),

              // Details
              const SizedBox(height: ESizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              // Heading Profile Info
              const ESectionHeading(
                title: 'Profile Information',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              Obx(
                () => EProfileMenu(
                  onPressed: () {},
                  title: 'Name',
                  value: controller.user.value.fullName,
                ),
              ),
              Obx(
                () => EProfileMenu(
                  onPressed: () {},
                  title: 'Username',
                  value: controller.user.value.username,
                ),
              ),

              const SizedBox(height: ESizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              // Heading Personal Info
              const ESectionHeading(
                title: 'Personal Information',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              Obx(
                () => EProfileMenu(
                  onPressed: () {},
                  title: 'User ID',
                  value: controller.user.value.id,
                  icon: Iconsax.copy,
                ),
              ),
              Obx(
                () => EProfileMenu(
                  onPressed: () {},
                  title: 'E-mail',
                  value: controller.user.value.email,
                ),
              ),
              Obx(
                () => EProfileMenu(
                  onPressed: () {},
                  title: 'Phone Number',
                  value: controller.user.value?.phoneNumber ?? '',
                ),
              ),
              EProfileMenu(onPressed: () {}, title: 'Gender', value: 'Male'),
              EProfileMenu(
                onPressed: () {},
                title: 'Date of Birth',
                value: '10 Oct, 1994',
              ),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),
            ],
          ),
        ),
      ),
    );
  }
}
