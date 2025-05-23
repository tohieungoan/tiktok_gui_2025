import 'package:flutter/material.dart';
import 'package:tiktok_app/core/constants.dart';

class customAddIcon extends StatelessWidget {
  const customAddIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 45,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 38,
            decoration: BoxDecoration(
              color: Color.fromARGB(250, 250, 45, 108),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 38,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 32, 211, 234),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                color: AppColors.trang,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                Icons.add,
                color: AppColors.den,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
