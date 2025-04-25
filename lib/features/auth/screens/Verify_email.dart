import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/core/widgets/button_login.dart';

class VerifyEmail extends StatefulWidget {
  final String email;

  const VerifyEmail({super.key, required this.email});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildOTPFields(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: width * 0.12,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            controller: _otpControllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              counterText: "",
              border: OutlineInputBorder(),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(
                  context,
                ).nextFocus(); // Tự chuyển sang ô tiếp theo
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(
                  context,
                ).previousFocus(); // Quay lại ô trước nếu xóa
              }
            },
          ),
        );
      }),
    );
  }

  void _showHelpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép cuộn nếu nội dung quá dài
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            width: double.infinity, // Chiều rộng tối đa
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Chọn một tùy chọn đăng nhập",
                  style: TextStyle(
                    color: AppColors.xamtrang,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/enterpassword',
                      arguments: widget.email,
                    );
                  },
                  child: const Text(
                    'Chuyển sang dùng mật khẩu',
                    style: TextStyle(
                      color: AppColors.den,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: AppColors.xamtrang, // Màu sắc của đường kẻ
                  thickness: 1, // Độ dày của đường kẻ
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Khôi phục mật khẩu',
                    style: TextStyle(
                      color: AppColors.den,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: AppColors.xam,
                  thickness: 10, // Độ dày của đường kẻ
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Hủy',
                    style: TextStyle(
                      color: AppColors.xamtrang,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
            Center(
              child: Column(
                children: [
                  Text(
                    "Xác minh email",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Nhập mã gồm 6 chữ số đã được gửi đến ${widget.email}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.xamtrang,
                      fontSize: screenWidth * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  buildOTPFields(screenWidth),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                // Xử lý gửi lại mã OTP
                print("Gửi lại mã OTP");
              },
              child: const Text(
                'Gửi lại mã',
                style: TextStyle(color: AppColors.dohong),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                _showHelpBottomSheet(); // Mở BottomSheet khi nhấn nút trợ giúp
              },
              child: const Text(
                'Bạn cần trợ giúp đăng nhập',
                style: TextStyle(color: AppColors.den),
              ),
            ),
            const Spacer(),
            ButtonLogin(
              onPressed: () {
                String otpCode = _otpControllers.map((c) => c.text).join();
                print("Mã OTP nhập vào: $otpCode");
                // Xử lý tiếp tục sau khi xác minh
                Navigator.pushNamed(context, '/Home');
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
