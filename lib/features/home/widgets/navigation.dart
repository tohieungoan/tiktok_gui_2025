import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/home/widgets/customAddIcon.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.hoiden,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.trang,
      unselectedItemColor: AppColors.trangduc,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 11,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.house),
          label: "Trang chủ",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.userGroup),
          label: "Bạn bè",
        ),

        // ✅ Nút ADD chính giữa
        BottomNavigationBarItem(
          icon: customAddIcon(),
          label: "", // không label để giống TikTok
        ),

        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.envelope),
          label: "Hộp thư",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.user),
          label: "Hồ sơ",
        ),
      ],
    );
  }
}
