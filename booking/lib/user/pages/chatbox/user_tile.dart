import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.text, this.onTap});
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          
          
        ),
        child: Row(
          children: [
            //icon
            Icon(Icons.person),
          ],
        ),
      ),
    );
  }
}