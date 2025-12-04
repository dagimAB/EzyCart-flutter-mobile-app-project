import 'package:ezycart/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';







class ECartCounterIcon extends StatelessWidget {
  const ECartCounterIcon({
    super.key,
    required this.onPressed,
    required this.iconColor,
  });

  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Shopping Bag Icon Button
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Iconsax.shopping_bag,
            color: iconColor,
          ),
        ),
        
        // 2. Positioned Counter Badge (e.g., '2' items)
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: EColors.black, 
              borderRadius: BorderRadius.circular(100), 
            ),
            child: Center(
              child: Text(
                '2', // Replace '2' with a variable from state management (e.g., itemCount)
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: EColors.white, 
                      fontSize: 10.0, 
                    ),
              ),
            ), 
          ), 
        ), 
      ],
    ); // Stack
  }
}