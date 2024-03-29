import 'package:flutter/material.dart';
import 'package:smart_wallet/features/onboarding_controller.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';
import 'package:smart_wallet/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Positioned(
        top: SW_DeviceUtils.getAppBarHeight(),
        right: SW_Sizes.defaultSpace,
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: Text(
            'Skip',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ));
  }
}
