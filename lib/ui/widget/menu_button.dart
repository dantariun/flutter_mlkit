import 'package:flutter/material.dart';

class MenuButonWidget extends StatelessWidget {
  final String title;
  final Color backgoundColor;
  final Color textColor;
  final double boxWidth;
  final double boxHeight;
  final double boxRadius;
  final void Function() onPressed;

  const MenuButonWidget({
    super.key,
    required this.title,
    required this.backgoundColor,
    required this.textColor,
    required this.boxWidth,
    required this.boxHeight,
    required this.boxRadius,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: boxWidth,
          height: boxHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: backgoundColor),
          child: TextButton(
            onPressed: onPressed,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
