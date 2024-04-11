import 'package:flutter/material.dart';

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
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
      margin: EdgeInsets.all(20.0),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(
                    onPressed: onPressed,
                    icon: Icon(Icons.edit),
                    color: Colors.blue.shade900,
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
