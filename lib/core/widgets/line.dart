import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color lineColor;

  const DividerWithText({
    super.key,
    required this.text,
    this.textColor = Colors.grey,
    this.lineColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            thickness: 1,
            color: lineColor,
            endIndent: 10,
          ),
        ),
        Text(
          text,
          style: TextStyle(color: textColor),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: lineColor,
            indent: 10,
          ),
        ),
      ],
    );
  }
}
