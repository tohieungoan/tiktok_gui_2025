// lib/widgets/like_button.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_app/core/constants.dart';

class Button extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final IconData? icon;
  const Button({
    super.key,
    this.onChanged,
    this.activeColor = Colors.red,
    this.inactiveColor = AppColors.xamtrang,
    this.icon = FontAwesomeIcons.solidHeart,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isClicked = false;
  int likeCount = 0; // Biến đếm số lượng thích

  void _toggleClick() {
    setState(() {
      isClicked = !isClicked;
      // Nếu button được click, tăng số lượng lên
      likeCount = isClicked ? likeCount + 1 : likeCount - 1;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(isClicked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _toggleClick,
          icon: FaIcon(
            widget.icon ?? FontAwesomeIcons.solidHeart,
            color: isClicked ? widget.activeColor : widget.inactiveColor,
            size: screenHeight * 0.04,
          ),
        ),
        Text(
          '$likeCount',
          style: TextStyle(
            fontSize: screenHeight * 0.02,
            fontWeight: FontWeight.bold,
            color: widget.inactiveColor,
          ),
        ),
      ],
    );
  }
}
