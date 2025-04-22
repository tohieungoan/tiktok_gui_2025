import 'package:flutter/material.dart';
import 'package:tiktok_app/core/constants.dart';

class CircularCheckbox extends StatelessWidget {
  const CircularCheckbox({super.key, required this.isChecked, this.size});

  final bool isChecked;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 30.0,
      height: size ?? 30.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isChecked ? AppColors.dohong : AppColors.den,
          width: 1.0,
        ),

        color: isChecked ? AppColors.dohong : AppColors.trang,
      ),
      child: Icon(
        isChecked ? Icons.check : null,
        color: Colors.white,
        size: size != null ? size! * 0.5 : 15.0,
      ),
    );
  }
}
