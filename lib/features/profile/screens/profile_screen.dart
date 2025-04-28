import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_app/features/auth/controllers/auth_service.dart';
import 'package:tiktok_app/features/profile/controller/ImageController.dart';
import 'package:tiktok_app/features/profile/widgets/avatar_widget.dart';
import 'package:tiktok_app/models/User.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:tiktok_app/features/profile/controller/UserController.dart'; // Import UserController

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final userController = Get.find<UserController>();
  final imageController = Get.find<ImageController>();
  final RxInt selectedIconIndex = 0.obs;
  final RxList<String> currentImages = <String>[].obs;
  final List<List<String>> imageUrls = [
    [
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ],
    [
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ],
    ["https://picsum.photos/200/300", "https://picsum.photos/200/300"],
    ["https://picsum.photos/200/300"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.userPlus),
          onPressed: () {
            print("User icon pressed!");
          },
        ),
        title: Obx(() {
          final user = userController.user.value;
          return Text('${user?.firstname} ${user?.lastname}');
        }),
        actions: [
          IconButton(
            onPressed: () {
              print("Setting pressed!");
            },
            icon: const FaIcon(FontAwesomeIcons.gear),
          ),
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: const FaIcon(FontAwesomeIcons.rightFromBracket),
          ),
        ],
      ),
      body: Obx(() {
        final user = userController.user.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarWidget(),
            const SizedBox(height: 10),
            Text("@${user?.username}"),
            const SizedBox(height: 10),
            _buildUserStats(user!),
            const SizedBox(height: 10),
            Text(
              user.bio?.isNotEmpty == true
                  ? user.bio!
                  : "Tiểu sử đang cập nhật...",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            _buildIconBar(),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: currentImages.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      currentImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildUserStats(Userapp user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatColumn("100", "Đã follow"),
        const SizedBox(width: 20),
        _buildStatColumn("200", "Follow"),
        const SizedBox(width: 20),
        _buildStatColumn("300", "Thích"),
        IconButton(
          onPressed: () {
            Get.toNamed('ChangeProfile');
          },
          icon: const FaIcon(FontAwesomeIcons.edit),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }

  Widget _buildIconBar() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(FontAwesomeIcons.solidHeart, 0),
          const SizedBox(width: 20),
          _buildIconButton(FontAwesomeIcons.commentDots, 1),
          const SizedBox(width: 20),
          _buildIconButton(FontAwesomeIcons.share, 2),
          const SizedBox(width: 20),
          _buildIconButton(FontAwesomeIcons.bookmark, 3),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, int index) {
    bool isSelected = selectedIconIndex.value == index;
    return GestureDetector(
      onTap: () => _changeImages(index),
      child: Column(
        children: [
          FaIcon(icon, color: isSelected ? Colors.yellow : Colors.black),
          Text(
            'Icon ${index + 1}',
            style: TextStyle(color: isSelected ? Colors.yellow : Colors.black),
          ),
        ],
      ),
    );
  }

  void _changeImages(int index) {
    selectedIconIndex.value = index;
    currentImages.value = imageUrls[index];
  }

  void _logout(context) async {
    await AuthService.logout(context);
    Get.offAllNamed('/login');
  }
}
