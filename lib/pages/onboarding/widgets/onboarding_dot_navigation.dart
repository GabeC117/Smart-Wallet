import 'package:flutter/material.dart';
import 'package:smart_wallet/features/onboarding_controller.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/device/device_utility.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = SW_Helpers.isDarkMode(context);

    return Positioned(
        bottom: SW_DeviceUtils.getBottomAppBarHeight() + 25,
        left: SW_Sizes.defaultSpace,
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: ExpandingDotsEffect(
              activeDotColor: dark ? SW_Colors.light : SW_Colors.dark,
              dotHeight: 6),
        ));
  }
}
