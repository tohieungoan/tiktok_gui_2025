import 'package:flutter/material.dart';
import 'package:tiktok_app/core/constants.dart';

class ButtonLogin extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? icon; // Đặt icon là có thể null
  final Text text;
  final Color? backgroundColor; // Thêm tham số để truyền màu nền
  final Color? textColor;

  const ButtonLogin({
    super.key,
    required this.onPressed,
    this.icon, // Có thể không truyền icon
    required this.text,
    this.backgroundColor, // Có thể không truyền màu nền
    this.textColor, // Có thể không truyền màu chữ
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ??
            AppColors.trang, // Dùng màu nền mặc định nếu không có
        foregroundColor: AppColors.den,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Kiểm tra nếu icon không phải null mới hiển thị
          if (icon != null) ...[
            IconTheme(data: IconThemeData(size: 20), child: icon!),
            const SizedBox(width: 8.0),
          ],
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text.data ?? "",
                style: TextStyle(
                  color:
                      textColor ??
                      AppColors
                          .den, // Màu chữ tùy chỉnh nếu có, nếu không có thì mặc định
                  fontSize:
                      text.style?.fontSize ??
                      16.0, // Giữ nguyên font size nếu có
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
