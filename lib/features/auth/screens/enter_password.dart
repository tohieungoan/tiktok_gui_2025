import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/core/widgets/button_login.dart';
import 'package:tiktok_app/features/auth/controllers/PasswordController.dart';
import 'package:tiktok_app/features/auth/controllers/auth_service.dart';

class Enterpassword extends StatelessWidget {
  final String email;
  Enterpassword({super.key, required this.email});
  final passwordController = TextEditingController();
  final passwordValidator = Get.put(PasswordController());
  Widget _buildValidationItem(bool isValid, String text) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: AppBar(
            backgroundColor: AppColors.trang,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text("Trợ giúp"),
                          content: const Text("Đây là trang nhập mật khẩu."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Đóng"),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Nhập mật khẩu",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Nhập mật khẩu",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        passwordValidator.validate(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => _buildValidationItem(
                passwordValidator.isLengthValid.value,
                "Mật khẩu phải dài từ 8 ký tự trở lên.",
              ),
            ),
            Obx(
              () => _buildValidationItem(
                passwordValidator.isComplexValid.value,
                "Nên có chữ hoa, chữ thường và số.",
              ),
            ),
            Obx(
              () => _buildValidationItem(
                passwordValidator.hasSpecialChar.value,
                "Phải có 1 kí tự đặc biệt",
              ),
            ),
            const Spacer(),
            ButtonLogin(
              onPressed: () async {
                if (passwordValidator.isAllValid) {
                  await AuthService.signInWithEmail(
                    context: context,
                    email: email,
                    password: passwordController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mật khẩu chưa thỏa yêu cầu!'),
                    ),
                  );
                }
              },
              icon: null,
              backgroundColor: AppColors.dohong,
              textColor: AppColors.trang,
              text: const Text('Tiếp tục'),
            ),
          ],
        ),
      ),
    );
  }
}
