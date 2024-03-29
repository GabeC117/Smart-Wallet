import 'package:flutter/material.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SW_Sizes.spaceBtwItems),
      child: Column(
        children: [
          Image(
            width: SW_Helpers.screenWidth() * 0.8,
            height: SW_Helpers.screenHeight() * 0.64,
            image: AssetImage(image),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: SW_Sizes.spaceBtwItems,
          ),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
