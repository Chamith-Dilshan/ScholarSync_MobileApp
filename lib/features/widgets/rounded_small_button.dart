import 'package:flutter/material.dart';

class RoundedSmallbutton extends StatelessWidget {
  final VoidCallback onPressed;
  final String lable;
  final Color backgroundColor;
  final Color textColor;
  final double fontsize;

  const RoundedSmallbutton({super.key,
    required this.onPressed,
    required this.lable,
    required this.backgroundColor,
    required this.textColor,
    required this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ), 
      child: Text(lable,style: TextStyle(color: textColor, fontSize: fontsize),),
    );
  }
}