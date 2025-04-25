import 'package:flutter/material.dart';
import 'package:tiktok_app/features/auth/screens/Create_password.dart';
import 'package:tiktok_app/features/auth/screens/Login_email.dart';
import 'package:tiktok_app/features/auth/screens/Login_screen.dart';
import 'package:tiktok_app/features/auth/screens/Register_screen.dart';
import 'package:tiktok_app/features/auth/screens/Select_birthdate.dart';
import 'package:tiktok_app/features/auth/screens/Verify_email.dart';
import 'package:tiktok_app/features/auth/screens/enter_password.dart';
import 'package:tiktok_app/features/home/screens/Home.dart';
import 'package:tiktok_app/features/home/screens/Other_Profile.dart';
import 'package:tiktok_app/features/policy/Loading.dart';
import 'package:tiktok_app/features/startup_screen.dart';
import 'package:tiktok_app/models/User.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(builder: (_) => const Loading());
      case '/startup':
        return MaterialPageRoute(builder: (_) => StartupScreen());
      case '/':
        return _createRoute(LoginScreen(), true);
      case '/register':
        return _createRoute(
          RegisterScreen(),
          false,
        ); // Trang Register trượt từ bên trái
      case '/createpassword':
        final email = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => Createpassword(email: email),
        ); // Trang CreatePassword không có hiệu ứng chuyển trang
      case '/selectbirthdate':
        return MaterialPageRoute(builder: (_) => const SelectBirthdate());
      case '/loginemail':
        return MaterialPageRoute(builder: (_) => const LoginEmail());
      case '/verifyemail':
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => VerifyEmail(email: email));
      case '/enterpassword':
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => Enterpassword(email: email));
      case '/Home':
        final user = settings.arguments as Userapp;
        return MaterialPageRoute(builder: (_) => HomeScreen(user: user));

      case '/OtherProfile':
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => OtherProfile(email: email));

      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('404 - Trang không tồn tại')),
              ),
        );
    }
  }

  static Route _createRoute(Widget page, bool fromRight) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Nếu từRight = true thì chuyển từ phải sang trái, ngược lại chuyển từ trái sang phải
        final begin =
            fromRight
                ? Offset(-1.0, 0.0)
                : Offset(
                  1.0,
                  0.0,
                ); // Nếu từRight = true thì bắt đầu từ bên phải
        const end = Offset.zero; // Kết thúc ở giữa màn hình
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        // Đặt hiệu ứng chuyển trang
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}


