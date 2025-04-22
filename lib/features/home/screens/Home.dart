import 'package:flutter/material.dart';
import 'package:tiktok_app/features/home/screens/home_screen_content.dart';
import 'package:tiktok_app/features/home/widgets/navigation.dart'; // BottomNavigationBar tùy chỉnh
import 'friend_screen.dart';
import 'upload_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const FriendScreen(),
     UploadScreen(),
    const ChatScreen(),
    const ProfileScreen(),
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
        body: _screens[_currentIndex],
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: _onNavTapped,
        ),
      ),
    );
  }
}
