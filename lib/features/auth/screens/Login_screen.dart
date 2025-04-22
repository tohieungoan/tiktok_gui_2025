import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/core/widgets/button_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenWidth / 9;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Đăng nhập vào TikTok",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.1,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              height: buttonHeight,
              width: screenWidth * 0.9,
              child: ButtonLogin(
                onPressed: () {
                  Navigator.pushNamed(context, '/loginemail');
                },
                icon: const FaIcon(FontAwesomeIcons.user, color: Colors.black),
                text: const Text('Tiếp tục với email/ tên người dùng'),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: buttonHeight,
              width: screenWidth * 0.9,
              child: ButtonLogin(
                onPressed: () {
                  print("Đăng nhập facebook");
                },
                icon: const FaIcon(
                  FontAwesomeIcons.facebook,
                  color: Colors.blue,
                ),
                text: const Text('Tiếp tục với Facebook'),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: buttonHeight,
              width: screenWidth * 0.9,
              child: ButtonLogin(
                onPressed: () {
                  print("Đăng nhập google");
                },
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                text: const Text('Tiếp tục với Google'),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.xamtrang,
                      fontSize: (screenWidth * 0.035),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Bằng việc tiếp tục với tài khoản có vị trí tại ",
                      ),
                      TextSpan(
                        text: "Việt Nam",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ", bạn đồng ý với "),
                      TextSpan(
                        text: "điều khoản dịch vụ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ", đồng thời bạn đã xác nhận rằng bạn đã đọc ",
                      ),
                      TextSpan(
                        text: "Chính sách quyền riêng tư ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "của chúng tôi "),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.08,
              color: AppColors.trangduc,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Bạn không có tài khoản? ",
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text(
                      "Đăng ký",
                      style: TextStyle(
                        color: AppColors.dohong,
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
