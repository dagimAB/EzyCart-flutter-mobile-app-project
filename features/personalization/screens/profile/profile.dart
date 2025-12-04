import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/images/e_circular_image.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const ECircularImage(image: EImages.productImage1, width: 80, height: 80),
                    TextButton(onPressed: () {}, child: const Text('Change Profile Picture')),
                  ],
                ),
              ),

              // Details
              const SizedBox(height: ESizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              // Heading Profile Info
              const ESectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: ESizes.spaceBtwItems),

              EProfileMenu(onPressed: () {}, title: 'Name', value: 'Coding with T'),
              EProfileMenu(onPressed: () {}, title: 'Username', value: 'coding_with_t'),

              const SizedBox(height: ESizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              // Heading Personal Info
              const ESectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: ESizes.spaceBtwItems),

              EProfileMenu(onPressed: () {}, title: 'User ID', value: '45689', icon: Iconsax.copy),
              EProfileMenu(onPressed: () {}, title: 'E-mail', value: 'support@codingwitht.com'),
              EProfileMenu(onPressed: () {}, title: 'Phone Number', value: '+92-317-8059525'),
              EProfileMenu(onPressed: () {}, title: 'Gender', value: 'Male'),
              EProfileMenu(onPressed: () {}, title: 'Date of Birth', value: '10 Oct, 1994'),
              const Divider(),
              const SizedBox(height: ESizes.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Close Account', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
