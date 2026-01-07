import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/images/e_rounded_image.dart';
import 'package:ezycart/features/admin/controllers/user/admin_user_controller.dart';
import 'package:ezycart/features/admin/screens/users/admin_user_detail.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminAllUsersScreen extends StatelessWidget {
  const AdminAllUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminUserController());

    return Scaffold(
      appBar: const EAppBar(title: Text('Manage Users'), showBackArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Column(
          children: [
            // Search Bar
            TextFormField(
              controller: controller.searchText,
              onChanged: (value) => controller.filterUsers(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.search_normal),
                hintText: 'Search by Name or Email',
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwSections),

            // User List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredUsers.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                return ListView.separated(
                  itemCount: controller.filteredUsers.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: ESizes.spaceBtwItems),
                  itemBuilder: (_, index) {
                    final user = controller.filteredUsers[index];
                    return ListTile(
                      onTap: () =>
                          Get.to(() => AdminUserDetailScreen(user: user)),
                      leading: ERoundedImage(
                        imageUrl: user.profilePicture.isNotEmpty
                            ? user.profilePicture
                            : EImages
                                  .user, // Ensure this asset constant exists or use placeholder
                        width: 50,
                        height: 50,
                        borderRadius: 50,
                        isNetworkImage: user.profilePicture.isNotEmpty,
                      ),
                      title: Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            'Role: ${user.role}',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.apply(
                                  color: user.role == "Admin"
                                      ? EColors.primary
                                      : null,
                                ),
                          ),
                        ],
                      ),
                      trailing: const Icon(Iconsax.arrow_right_34, size: 18),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
