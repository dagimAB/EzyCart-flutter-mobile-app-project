import 'package:ezycart/bindings/general_bindings.dart';
import 'package:ezycart/features/authentication/screens/login/login.dart';
import 'package:ezycart/features/authentication/screens/splash/splash_screen.dart';
import 'package:ezycart/navigation_menu.dart';
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
      initialBinding: GeneralBindings(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/LoginScreen', page: () => const LoginScreen()),
        GetPage(name: '/NavigationMenu', page: () => const NavigationMenu()),
      ],
      home: const SplashScreen(),
    );
  }
}
