import 'package:get/get.dart';
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
import 'package:tiktok_app/features/profile/screens/change_profile.dart';
import 'package:tiktok_app/features/startup_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/startup',
      page: () => StartupScreen(),
    ),
    GetPage(
      name: '/',
      page: () => LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/register',
      page: () => RegisterScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/createpassword',
      page: () => Createpassword(email: Get.arguments), // vẫn cần arguments (email lúc tạo tài khoản)
    ),
    GetPage(
      name: '/selectbirthdate',
      page: () => SelectBirthdate(),
    ),
    GetPage(
      name: '/loginemail',
      page: () => LoginEmail(),
    ),
    GetPage(
      name: '/verifyemail',
      page: () => VerifyEmail(email: Get.arguments), 
    ),
    GetPage(
      name: '/enterpassword',
      page: () => Enterpassword(email: Get.arguments), 
    ),
    GetPage(
      name: '/Home',
      page: () => HomeScreen(), 
    ),
    GetPage(
      name: '/ChangeProfile',
      page: () => EditProfileScreen(), 
    ),
    GetPage(
      name: '/OtherProfile',
      page: () => OtherProfile(email: Get.arguments), 
    ),
  ];
}
