import 'package:flutter/material.dart';
import 'package:smart_wallet/utils/constants/colors.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';

import '../utils/theme/custom_themes/text_field_theme.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox(
      {Key? key,
      required this.text,
      required this.sectionName,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = SW_Helpers.isDarkMode(context);

    return Container(
      decoration: BoxDecoration(
          color: dark? Colors.grey[850] : Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
      margin: const EdgeInsets.all(20.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Section Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sectionName,
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                // Button
                Material(
                  color: dark? Colors.grey[850] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.edit),
                    color: SW_Colors.primary,
                  ),
                ),
              ],
            ),

            // Text
            Text(text),
          ]),
    );
  }
}
