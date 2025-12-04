import 'package:ezycart/common/widgets/images/e_circular_image.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EUserProfileTile extends StatelessWidget {
  const EUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const ECircularImage(
        image: EImages.productImage1, // Use a user image here
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text('Coding with T', style: Theme.of(context).textTheme.headlineSmall!.apply(color: EColors.white)),
      subtitle: Text('support@codingwitht.com', style: Theme.of(context).textTheme.bodyMedium!.apply(color: EColors.white)),
      trailing: IconButton(onPressed: onPressed, icon: const Icon(Iconsax.edit, color: EColors.white)),
    );
  }
}
