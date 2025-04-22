import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/core/widgets/CircularCheckbox.dart';
import 'package:tiktok_app/core/widgets/button_login.dart';
import 'package:tiktok_app/core/widgets/line.dart';
import 'package:tiktok_app/core/widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenWidth / 9;
    final TextEditingController emailController = TextEditingController();
    bool isChecked = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Đăng ký TikTok",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.1,
                ),
              ),
            ),

            SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  TextFieldds(
                    label: "Email",
                    hintText: "Nhập vào email của bạn",
                    controller: emailController,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: Row(
                      children: [
                        CircularCheckbox(
                          isChecked: isChecked,
                          size: screenWidth * 0.04,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Lưu thông tin đăng nhập để đăng nhập vào lần sau",
                            softWrap: true,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: AppColors.xamtrang,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: buttonHeight * 1.2,
                      width: screenWidth * 0.9,
                      child: ButtonLogin(
                        onPressed: () {
                          String email = emailController.text.trim();
                          String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                          RegExp regex = RegExp(pattern);
                          if (email.isEmpty) {
                            print("Email không được để trống");
                          } else if (!regex.hasMatch(email)) {
                            print("Email không đúng định dạng");
                          } else {
                            Navigator.pushNamed(context, '/createpassword');
                          }
                        },
                        icon: null,
                        backgroundColor: AppColors.dohong,
                        textColor: AppColors.trang,
                        text: const Text('Tiếp tục'),
                      ),
                    ),
                  ),

                  DividerWithText(
                    text: "hoặc",
                    textColor: AppColors.den,
                    lineColor: AppColors.xamtrang,
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
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      text: const Text('Tiếp tục với Google'),
                    ),
                  ),
                ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Bạn đã có tài khoản? ",
                    style: TextStyle(fontSize: (screenWidth * 0.04)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Center(
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: AppColors.dohong,
                          fontSize: (screenWidth * 0.04),
                          fontWeight: FontWeight.bold,
                        ),
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
