import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/images/e_circular_image.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/admin/controllers/user/admin_user_controller.dart';
import 'package:ezycart/features/personalization/models/user_model.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminUserDetailScreen extends StatelessWidget {
  const AdminUserDetailScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final controller = AdminUserController.instance;
    // Local state for role dropdown to avoid complex obs setup for one field
    final role = user.role.obs;

    return Scaffold(
      appBar: const EAppBar(title: Text('User Details'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              // Profile Picture
              ECircularImage(
                image: user.profilePicture.isNotEmpty
                    ? user.profilePicture
                    : EImages.user,
                isNetworkImage: user.profilePicture.isNotEmpty,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),
              Text(
                user.fullName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: ESizes.spaceBtwSections),

              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              // Details
              const ESectionHeading(
                title: 'Account Information',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              _buildDetailRow('User ID', user.id, context),
              _buildDetailRow('Username', user.username, context),
              _buildDetailRow('Phone', user.phoneNumber, context),

              const SizedBox(height: ESizes.spaceBtwSections),

              // Actions
              const ESectionHeading(
                title: 'Admin Actions',
                showActionButton: false,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              // Role Changer
              Obx(
                () => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Role'),
                  value: role.value,
                  items: ['User', 'Admin'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) role.value = val;
                  },
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Create updated user object
                    // We modify the copy
                    final updatedUser = UserModel(
                      id: user.id,
                      firstName: user.firstName,
                      lastName: user.lastName,
                      username: user.username,
                      email: user.email,
                      phoneNumber: user.phoneNumber,
                      profilePicture: user.profilePicture,
                      role: role.value,
                    );
                    controller.updateUser(updatedUser);
                  },
                  child: const Text('Update Role'),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              // Delete User
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Delete User',
                      middleText:
                          'Are you sure you want to delete this user? This action cannot be undone and deletes the database record.',
                      textConfirm: 'Delete',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back(); // Close dialog
                        controller.deleteUser(user.id);
                        Get.back(); // Close screen
                      },
                    );
                  },
                  child: const Text('Delete User (Database Only)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            flex: 2,
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
