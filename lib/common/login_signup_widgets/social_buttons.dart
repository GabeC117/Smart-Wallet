import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/constants/image_strings.dart';
import 'package:smart_wallet/utils/constants/sizes.dart';

import '../../utils/helpers/helper_functions.dart';

class socialButtons extends StatelessWidget {
  const socialButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 65, // Set the desired width
          height: 65,
          decoration: BoxDecoration(
              border: Border.all(color: SW_Colors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
                width: SW_Sizes.iconLg,
                height: SW_Sizes.iconLg,
                image: AssetImage(SW_Images.google)),
          ),
        ),
        const SizedBox(width: SW_Sizes.spaceBtwItems * 2),
        Container(
          width: 65, // Set the desired width
          height: 65,
          decoration: BoxDecoration(
              border: Border.all(color: SW_Colors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: Image(
                width: SW_Sizes.iconLg,
                height: SW_Sizes.iconLg,
                image:
                    AssetImage(dark ? SW_Images.appleWhite : SW_Images.apple)),
          ),
        ),
      ],
    );
  }
}
