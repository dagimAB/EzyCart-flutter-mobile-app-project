import 'package:ezycart/common/widgets/images/e_circular_image.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EUserProfileTile extends StatelessWidget {
  const EUserProfileTile({
    super.key,
    required this.onPressed,
    required this.title,
    required this.subtitle,
    this.imageUrl,
  });

  final VoidCallback onPressed;
  final String title;
  final String subtitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    return ListTile(
      leading: ECircularImage(
        image: hasImage ? imageUrl! : EImages.user,
        isNetworkImage: hasImage,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall!.apply(color: EColors.white),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.apply(color: EColors.white),
      ),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(Iconsax.edit, color: EColors.white),
      ),
    );
  }
}
