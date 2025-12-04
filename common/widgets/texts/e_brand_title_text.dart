import 'package:ezycart/utils/constants/enums.dart';
import 'package:flutter/material.dart';

class EBrandTitleText extends StatelessWidget {
  const EBrandTitleText({
    super.key,
    this.color,
    this.maxLines = 1,
    required this.title,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSize.small,
  });

  final Color? color;
  final String title;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSize brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      // Check which brandSize is required and set that style
      style: brandTextSize == TextSize.small
          ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
          : brandTextSize == TextSize.medium
          ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
          : brandTextSize == TextSize.large
          ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
          : Theme.of(context).textTheme.bodyMedium!.apply(color: color),
    );
  }
}
