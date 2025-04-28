import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/home/widgets/CoumnItem.dart';
import 'package:tiktok_app/features/home/widgets/search_delegate.dart';
import 'package:tiktok_app/features/profile/controller/UserController.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userController = Get.find<UserController>();
    final user = userController.user.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.hoiden,
        toolbarHeight: 42, // Hoặc: kToolbarHeight * 0.75
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTab("Bạn bè", 0, screenWidth),
            const SizedBox(width: 16),
            _buildTab("Đã follow", 1, screenWidth),
            const SizedBox(width: 16),
            _buildTab("Đề xuất", 2, screenWidth),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: screenWidth * 0.08,
              color: AppColors.trang,
            ),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              selectedIndex == 0
                  ? "Hiển thị video bạn bè"
                  : selectedIndex == 1
                  ? "Hiển thị video đã follow"
                  : "Hiển thị video đề xuất",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Positioned(
            right: 8,
            top: MediaQuery.of(context).size.height / 4,
            child: ListItem(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index, double screenWidth) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenWidth * 0.042,
          fontWeight: FontWeight.bold,
          color: isSelected ? AppColors.trang : AppColors.xam,
          decoration:
              isSelected ? TextDecoration.underline : TextDecoration.none,
          decorationColor: AppColors.trang,
          decorationThickness: 2.5,
          decorationStyle: TextDecorationStyle.solid,
        ),
      ),
    );
  }
}
