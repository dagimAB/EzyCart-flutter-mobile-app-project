import 'package:ezycart/utils/constants/colors.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ETextFormFieldTheme {
  ETextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: EColors.darkGrey,
    suffixIconColor: EColors.darkGrey,
    labelStyle: const TextStyle().copyWith(
      fontSize: ESizes.fontSizeMd,
      color: EColors.black,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: ESizes.fontSizeMd,
      color: EColors.black,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Color.fromRGBO(0, 0, 0, 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.grey),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.grey),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: EColors.error),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: EColors.darkGrey,
    suffixIconColor: EColors.darkGrey,
    labelStyle: const TextStyle().copyWith(
      fontSize: ESizes.fontSizeMd,
      color: EColors.white,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: ESizes.fontSizeMd,
      color: EColors.white,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Color.fromRGBO(255, 255, 255, 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(ESizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: EColors.darkGrey),
    ),
  );
}
