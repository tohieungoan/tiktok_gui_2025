import 'package:flutter/material.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/core/widgets/button_login.dart';

class Createpassword extends StatefulWidget {
  const Createpassword({super.key});

  @override
  State<Createpassword> createState() => _CreatepasswordState();
}

class _CreatepasswordState extends State<Createpassword> {
  bool _obscurePassword = true; // Mật khẩu đang bị ẩn

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
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
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
          crossAxisAlignment:
              CrossAxisAlignment.start, // Căn trái cho phần text phía dưới
          children: [
            Center(
              // Căn giữa phần Tạo mật khẩu và TextField
              child: Column(
                children: [
                  Text(
                    "Tạo mật khẩu",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300, // Đặt độ rộng TextField cho hợp lý
                    child: TextField(
                      textAlign: TextAlign.left, // Căn giữa nội dung nhập
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Nhập mật khẩu",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "✔ Mật khẩu phải dài từ 8 ký tự trở lên.",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "✔ Nên có chữ hoa, chữ thường và số.",
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              "✔ Không nên dùng ngày sinh.",
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(), // Đây sẽ đẩy nút "Tiếp tục" xuống dưới cùng
            ButtonLogin(
              onPressed: () {
                Navigator.pushNamed(context, '/selectbirthdate');
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
