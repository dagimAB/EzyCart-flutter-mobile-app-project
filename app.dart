import 'package:ezycart/features/authentication/screens/onBoarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:ezycart/utils/theme/theme.dart';
import 'package:get/get.dart';

// // --Used to setup themes, Initialize bindings, animation and such things

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: EAppTheme.lightTheme,
      darkTheme: EAppTheme.darkTheme,
      home: const OnBoardingScreen(),
    );
  }
}
