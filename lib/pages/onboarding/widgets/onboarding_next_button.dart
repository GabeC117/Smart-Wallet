import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smart_wallet/features/onboarding_controller.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';
import 'package:smart_wallet/utils/device/device_utility.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);
    return Positioned(
      right: SW_Sizes.defaultSpace,
      bottom: SW_DeviceUtils.getBottomAppBarHeight() - 15,
      child: ElevatedButton(
          onPressed: () => OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            primary: dark ? SW_Colors.primary : Colors.black,
          ),
          child: const Icon(
            Iconsax.arrow_right_3,
          )),
    );
  }
}
