import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_wallet/pages/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// Update Current Index when Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to the specific dot selected page.
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 250), // Adjust duration as needed
      curve: Curves.easeInOut, // Adjust curve as needed
    );
  }

  /// Update Current Index & jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      Get.to(LoginPage());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  /// Update Current Index & jump to the login page
  void skipPage() {
    Get.to(LoginPage());
  }
}
