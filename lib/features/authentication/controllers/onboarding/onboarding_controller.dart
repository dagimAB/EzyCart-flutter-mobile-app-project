import 'package:ezycart/features/authentication/screens/login/login.dart';
import 'package:ezycart/services/secure_storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// Update Current Index when page scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to the specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// Update current index & jump to next page
  void nextPage() async {
    if (currentPageIndex.value == 2) {
      // Mark onboarding as seen only when user finishes it
      await SecureStorageService.instance.writeSecureData(
        'hasSeenOnboarding',
        'true',
      );
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  /// Skip onboarding entirely and mark as seen
  void skipPage() async {
    await SecureStorageService.instance.writeSecureData(
      'hasSeenOnboarding',
      'true',
    );
    Get.offAll(const LoginScreen());
  }
}
