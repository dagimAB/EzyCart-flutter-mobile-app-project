import 'package:ezycart/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ezycart/common/widgets/texts/product_price_text.dart';
import 'package:ezycart/common/widgets/texts/product_title_text.dart';
import 'package:ezycart/common/widgets/texts/section_heading.dart';
import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:ezycart/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class EProductAttributes extends StatelessWidget {
  const EProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        // -- Selected Attribute Pricing & Description
        ERoundedContainer(
          padding: const EdgeInsets.all(ESizes.md),
          backgroundColor: dark ? EColors.darkerGrey : EColors.grey,
          child: Column(
            children: [
              // Title, Price and Stock Status
              Row(
                children: [
                  const ESectionHeading(title: 'Variation', showActionButton: false),
                  const SizedBox(width: ESizes.spaceBtwItems),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const EProductTitleText(title: 'Price : ', smallSize: true),
                          // Actual Price
                          Text(
                            '\$25',
                            style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(width: ESizes.spaceBtwItems),
                          // Sale Price
                          const EProductPriceText(price: '20'),
                        ],
                      ),

                      // Stock
                      Row(
                        children: [
                          const EProductTitleText(title: 'Stock : ', smallSize: true),
                          Text('In Stock', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // Variation Description
              const EProductTitleText(
                title: 'This is the description of the Product and it can go up to max 4 lines.',
                smallSize: true,
                maxLines: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: ESizes.spaceBtwItems),

        // -- Attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ESectionHeading(title: 'Colors', showActionButton: false),
            const SizedBox(height: ESizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                EChoiceChip(text: 'Green', selected: true, onSelected: (value) {}),
                EChoiceChip(text: 'Blue', selected: false, onSelected: (value) {}),
                EChoiceChip(text: 'Yellow', selected: false, onSelected: (value) {}),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ESectionHeading(title: 'Size', showActionButton: false),
            const SizedBox(height: ESizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: [
                EChoiceChip(text: 'EU 34', selected: true, onSelected: (value) {}),
                EChoiceChip(text: 'EU 36', selected: false, onSelected: (value) {}),
                EChoiceChip(text: 'EU 38', selected: false, onSelected: (value) {}),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class EChoiceChip extends StatelessWidget {
  const EChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = EHelperFunctions.getColor(text) != null;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: isColor ? const SizedBox() : Text(text),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? EColors.white : null),
        avatar: isColor
            ? ERoundedContainer(width: 50, height: 50, backgroundColor: EHelperFunctions.getColor(text)!)
            : null,
        labelPadding: isColor ? const EdgeInsets.all(0) : null,
        padding: isColor ? const EdgeInsets.all(0) : null,
        shape: isColor ? const CircleBorder() : null,
        backgroundColor: isColor ? EHelperFunctions.getColor(text)! : null,
      ),
    );
  }
}
