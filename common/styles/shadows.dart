import 'package:ezycart/utils/constants/colors.dart';

import 'package:flutter/material.dart';

class EShadowStyle{
  static final verticalProductShadow = BoxShadow(
    color: EColors.darkGrey.withAlpha(51),
    spreadRadius: 7,
    blurRadius: 50,
    offset: const Offset(0, 2), // changes position of shadow
  );


  static final horizontalProductShadow = BoxShadow(
    color: EColors.darkGrey.withAlpha(51),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0,2)
  );
}
