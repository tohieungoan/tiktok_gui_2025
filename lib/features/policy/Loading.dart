import 'package:flutter/material.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/auth/screens/Login_screen.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();

    // Đảm bảo gọi Navigator sau frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.trangduc,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Stack(
            children: [
              // Text giới thiệu
              SizedBox(
                width: screenWidth * 0.6,
                child: Text(
                  'Video để Cho ngày của bạn tươi đẹp hơn',
                  style: TextStyle(
                    fontSize: screenWidth * 0.075,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              // Logo ở dưới cùng bên trái
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

              const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
