import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/home/controllers/ApiFollow.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';
import 'package:tiktok_app/features/home/screens/home_screen_content.dart';
import 'package:tiktok_app/models/User.dart';

bool isImage(String url) {
  return url.endsWith(".jpg") ||
      url.endsWith(".jpeg") ||
      url.endsWith(".png") ||
      url.endsWith(".gif");
}

bool isVideo(String url) {
  return url.endsWith(".mp4") ||
      url.endsWith(".mov") ||
      url.endsWith(".avi") ||
      url.endsWith(".mkv");
}

class OtherProfile extends StatelessWidget {
  final Userapp user;
  final PostController postController = Get.find<PostController>();

  OtherProfile({super.key, required this.user}) {
    // Gọi API sau frame build
    Future.microtask(() {
      postController.fetchPostUser(user.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.leftLong),

          onPressed: () {
            // Resetting values when navigating back
            postController.iswatchpostuser.value = false;
            postController.currentPostUserIndex.value ;
            postController.postuser.value = [];
            Navigator.pop(context);
          },
        ),
        title: Text("${user.firstname} ${user.lastname}"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.bell),
          ),
          IconButton(
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.share),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarWidget(avatarUrl: user.avatar.toString()),
          const SizedBox(height: 10),
          Text(
            user.username ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            //   _buildStatColumn("100", "Đã follow"),
            //   const SizedBox(width: 20),
            //   _buildStatColumn("200", "Follow"),
            //   const SizedBox(width: 20),
            //   _buildStatColumn("300", "Thích"),
            // ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => TextButton(
                  onPressed: () async {
                    if (postController.isFollow.value == false) {
                      await ApiFollow.createFollow(
                        context: context,
                        iduser: user.id.toString(),
                      );
                    } else {
                      await ApiFollow.unFollow(
                        context: context,
                        iduser: user.id.toString(),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        postController.isFollow.value
                            ? Colors.grey
                            : AppColors.dohong,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    postController.isFollow.value ? "Hủy follow" : "Follow",
                    style: const TextStyle(color: AppColors.trang),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.trang,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Nhắn tin",
                  style: TextStyle(color: AppColors.den),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text("${user.bio.toString()}"),
          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (postController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: postController.postuser.length,
                itemBuilder: (context, index) {
                  final post = postController.postuser[index];

                  String mediaUrl = post.media ?? '';
                  if (isVideo(mediaUrl)) {
                    mediaUrl = mediaUrl.replaceAll(
                      RegExp(r'\.(mp4|mov|avi|mkv)$'),
                      '.jpg',
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      postController.iswatchpostuser.value = true;
                      postController.currentPostUserIndex.value = index;
                      postController.currentPostIndex.value = 0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreenContent(),
                        ),
                      );
                    },
                    child: Image.network(
                      mediaUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}

class AvatarWidget extends StatelessWidget {
  final String avatarUrl; // Thay đổi kiểu dữ liệu thành String
  const AvatarWidget({
    super.key,
    required this.avatarUrl,
  }); // Thay đổi kiểu dữ liệu thành String

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              avatarUrl, // Sử dụng avatarUrl từ widget
            ),
          ),
        ],
      ),
    );
  }
}
