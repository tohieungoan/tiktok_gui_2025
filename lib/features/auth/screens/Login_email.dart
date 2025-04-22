import 'package:flutter/material.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/core/widgets/button_login.dart';

class LoginEmail extends StatefulWidget {
  const LoginEmail({super.key});

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose(); // tránh rò rỉ bộ nhớ
    super.dispose();
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
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              "Đăng nhập",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text("Trợ giúp"),
                          content: const Text("Đây là trang trợ giúp."),
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
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Nhập email hoặc TikTokID",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const Spacer(),
            ButtonLogin(
              onPressed: () {
                final email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    '/verifyemail',
                    arguments: email,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Vui lòng nhập email")),
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
