import 'package:flutter/material.dart';
import 'package:tiktok_app/features/profile/controller/get_current_user_by_token.dart';

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    try {
      final user = await GetUserByToken.getUserByToken();

      if (!mounted) return;

      if (user != null) {
        print("Đăng nhập thành công");
        Navigator.pushReplacementNamed(context, '/Home', arguments: user);
      } else {
        print("Chưa đăng nhập");
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      print("Lỗi kiểm tra user: $e");
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
