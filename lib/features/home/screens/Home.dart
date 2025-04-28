import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/features/profile/controller/UserController.dart';
import 'package:tiktok_app/features/home/widgets/navigation.dart';
import 'package:tiktok_app/features/home/screens/home_screen_content.dart';
import 'friend_screen.dart';
import '../../upload/screens/upload_screen.dart';
import 'chat_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final userController = Get.find<UserController>();

  final List<Widget> _screens = [
    HomeScreenContent(),
    FriendScreen(),
    UploadScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          final user = userController.user.value;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _screens[_currentIndex];
          }
        }),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: _onNavTapped,
        ),
      ),
    );
  }
}
