import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final Key testKey;

  const MyButton({
    Key? key,
    required this.onTap,
    required this.testKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: testKey,
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
              color: Color(0xFF065A82), borderRadius: BorderRadius.circular(8)),
          child: const Center(
            child: Text(
              'Log In',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )),
    );
  }
}
