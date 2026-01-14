import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:ezycart/features/shop/screens/cart/cart.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/text_strings.dart';
import 'package:ezycart/features/personalization/controllers/user_controller.dart';
import 'package:ezycart/features/ai/screens/ai_chat_screen.dart';
import 'package:ezycart/features/shop/screens/search/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EHomeAppBar extends StatelessWidget {
  const EHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return EAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ETexts.homeAppBarTitle,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.apply(color: EColors.grey),
          ),
          Text(
            ETexts.homeAppBarSubTitle,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.apply(color: EColors.white),
          ),
          Obx(
            () => Text(
              controller.user.value.fullName,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.apply(color: EColors.white),
            ),
          ),
        ],
      ), // Column
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => Get.to(() => const SearchScreen()),
        ),
        ECartCounterIcon(
          onPressed: () => Get.to(() => const CartScreen()),
          iconColor: EColors.white,
        ),
        // AI Assistant entry point
        IconButton(
          icon: const Icon(Icons.smart_toy, color: Colors.white),
          tooltip: 'AI Assistant',
          onPressed: () => Get.to(() => const AiChatScreen()),
        ),
      ],
    );
  }
}
