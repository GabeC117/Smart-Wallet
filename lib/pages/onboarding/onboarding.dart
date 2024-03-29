import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_wallet/features/onboarding_controller.dart';
import 'package:smart_wallet/utils/constants/image_strings.dart';
import 'package:smart_wallet/utils/constants/text_strings.dart';
import 'package:smart_wallet/pages/onboarding/widgets/onboarding_page.dart';
import 'package:smart_wallet/pages/onboarding/widgets/onboarding_skip.dart';
import 'package:smart_wallet/pages/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:smart_wallet/pages/onboarding/widgets/onboarding_next_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: SW_Images.onBoardingImage1,
                title: SW_Texts.onBoardingTitle1,
                subTitle: SW_Texts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: SW_Images.onBoardingImage2,
                title: SW_Texts.onBoardingTitle2,
                subTitle: SW_Texts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: SW_Images.onBoardingImage3,
                title: SW_Texts.onBoardingTitle3,
                subTitle: SW_Texts.onBoardingSubTitle3,
              )
            ],
          ),

          // Skip Button
          const OnBoardingSkip(),

          // Dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          // Next Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
