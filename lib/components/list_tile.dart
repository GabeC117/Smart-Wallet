import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  const MyListTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: Colors.purple.shade100),
        onTap: onTap,
        title: Text(
          text,
          style: TextStyle(color: Colors.purple.shade100),
        ),
      ),
    );
  }
}
