import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_app/blocs/user/user_bloc.dart';
import 'package:tiktok_app/models/User.dart';
import 'package:tiktok_app/features/home/widgets/navigation.dart';
import 'package:tiktok_app/features/home/screens/home_screen_content.dart';
import 'friend_screen.dart';
import 'upload_screen.dart';
import 'chat_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final Userapp user; // Thêm biến user để nhận dữ liệu từ route
  const HomeScreen({
    super.key,
    required this.user, // Nhận dữ liệu từ route
  });

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
    return BlocProvider(
      create: (context) => UserBloc(widget.user),  // Cung cấp UserBloc với thông tin user ban đầu
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserInitial) {
                // Trạng thái khi người dùng được tải
                Userapp user = state.user;  // Lấy thông tin người dùng từ BLoC
                return _screens[_currentIndex];  // Chọn màn hình theo index
              } else if (state is UserUpdating) {
                return const Center(child: CircularProgressIndicator());  // Đang cập nhật
              } else if (state is UserUpdated) {
                // Trạng thái sau khi cập nhật thành công
                return _screens[_currentIndex];  // Hiển thị màn hình đã được cập nhật
              } else if (state is UserUpdateError) {
                // Lỗi khi cập nhật
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: CircularProgressIndicator());  // Mặc định
            },
          ),
          bottomNavigationBar: CustomBottomNav(
            currentIndex: _currentIndex,
            onTap: _onNavTapped,
          ),
        ),
      ),
    );
  }
}
