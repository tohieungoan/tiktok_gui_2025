import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/home/controllers/CommentController.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';
import 'package:tiktok_app/features/home/widgets/CoumnItem.dart';
import 'package:tiktok_app/features/home/widgets/VideoPlayerWidget.dart';
import 'package:tiktok_app/features/home/widgets/search_delegate.dart';
import 'package:tiktok_app/features/profile/controller/UserController.dart';
import 'package:video_player/video_player.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  int selectedIndex = 0;
  VideoPlayerController? _videoController;
  final isReloading = false.obs;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    if (isReloading.value) return; // tránh gọi nhiều lần
    isReloading.value = true;
    final post = Get.find<PostController>();
if(post.iswatchpostuser.value==false){
      post.clearPosts();
    await post.fetchRandomPost();
    await Future.delayed(const Duration(seconds: 1)); // giả lập loading
    isReloading.value = false;
}
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userController = Get.find<UserController>();
    final user = userController.user.value;
    final post = Get.find<PostController>();

    return Scaffold(
      body: Obx(() {
        var posts = post.iswatchpostuser.value ? post.postuser : post.posts;
      if (post.isLoading.value && posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isNotEmpty) {
      post.checkFollowing(posts[post.currentPostIndex.value]);
    }

        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is OverscrollNotification &&
                    notification.overscroll < 0 &&
                    post.currentPostIndex.value == 0 &&
                    !isReloading.value) {
                  _onRefresh();
                }
                return false;
              },
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                itemCount: posts.length,
                controller: PageController(
                  initialPage:
                      post.iswatchpostuser.value
                          ? post.currentPostUserIndex.value
                          : post.currentPostIndex.value,
                ),
                onPageChanged: (index) {
                  if (!post.iswatchpostuser.value) {
                    post.currentPostIndex.value = index;
                    if (index >= posts.length - 2) {
                      post.fetchRandomPost();
                    }
                  } else {
                    post.currentPostUserIndex.value = index;
                  }
                },
                itemBuilder: (context, index) {
                  final currentPost = posts[index];
                  final mediaUrl = currentPost.media;

                  return Stack(
                    children: [
                      if (mediaUrl != null && mediaUrl.endsWith('.mp4'))
                        VideoPlayerWidget(currentMediaUrl: mediaUrl),
                      if (mediaUrl != null &&
                          (mediaUrl.endsWith('.jpg') ||
                              mediaUrl.endsWith('.png')))
                        Image.network(
                          mediaUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      Positioned(
                        right: 8,
                        top: MediaQuery.of(context).size.height / 4,
                        child: ListItem(currentPost),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${currentPost.user?.firstname ?? ""} ${currentPost.user?.lastname ?? ""}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentPost.description ?? "Không có mô tả",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Loading indicator khi reload
            Obx(
              () =>
                  isReloading.value
                      ? Positioned(
                        top: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      )
                      : const SizedBox(),
            ),
            // AppBar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!post.iswatchpostuser.value)
                      _buildTab("Đề xuất", 0, screenWidth),
                    if (!post.iswatchpostuser.value)
                      _buildTab("Đã follow", 1, screenWidth),
                    if (!post.iswatchpostuser.value)
                      _buildTab("Bạn bè", 2, screenWidth),
                    if (!post.iswatchpostuser.value)
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          size: screenWidth * 0.08,
                          color: AppColors.trang,
                        ),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: CustomSearchDelegate(),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
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
