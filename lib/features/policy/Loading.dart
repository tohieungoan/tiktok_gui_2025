import 'package:flutter/material.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/auth/screens/Login_screen.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: AppColors.trangduc,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Stack(
            children: [
              SizedBox(
                width: screenWidth * 0.5,
                child: Text(
                  'Video để Cho ngày của bạn tươi đẹp hơn',
                  style: TextStyle(
                    fontSize: screenWidth * 0.082,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: screenWidth * 0.3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset("assets/images/logo_text.png"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
