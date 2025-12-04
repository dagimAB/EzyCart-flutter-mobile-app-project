import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class EOverallProductRating extends StatelessWidget {
  const EOverallProductRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text('4.8', style: Theme.of(context).textTheme.displayLarge),
        ),
        Expanded(
          flex: 7,
          child: Column(
            children: [
              ERatingProgressIndicator(text: '5', value: 1.0),
              ERatingProgressIndicator(text: '4', value: 0.8),
              ERatingProgressIndicator(text: '3', value: 0.6),
              ERatingProgressIndicator(text: '2', value: 0.4),
              ERatingProgressIndicator(text: '1', value: 0.2),
            ],
          ),
        ),
      ],
    );
  }
}

class ERatingProgressIndicator extends StatelessWidget {
  const ERatingProgressIndicator({
    super.key,
    required this.text,
    required this.value,
  });

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: EDeviceUtils.getScreenWidth(context) * 0.8,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: EColors.grey,
              borderRadius: BorderRadius.circular(7),
              valueColor: const AlwaysStoppedAnimation(EColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
