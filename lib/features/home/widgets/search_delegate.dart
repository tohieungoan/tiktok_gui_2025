import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';
import 'package:tiktok_app/features/home/screens/Other_Profile.dart';
import 'package:tiktok_app/features/home/screens/home_screen_content.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> dummyData = [
    'Flutter',
    'TikTok UI',
    'Video Editor',
    'Funny Video',
    'Trending',
    'Tutorial',
  ];

  final PostController postController = Get.find<PostController>();

  bool isVideo(String url) {
    return url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.avi') ||
        url.endsWith('.mkv');
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          postController.postuser.value = [];
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  void showResults(BuildContext context) {
    if (query.startsWith("@")) {
      String username = query.substring(1).trim();
      postController.fetchUserSearch(username);
    } else {
      postController.fetchPostsearch(query);
    }
    super.showResults(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Obx(() {
      if (postController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (query.startsWith("@")) {
        // Hiển thị danh sách user
        if (postController.users.isEmpty) {
          return const Center(child: Text('Không tìm thấy người dùng'));
        } else {
          return ListView.builder(
            itemCount: postController.users.length,
            itemBuilder: (context, index) {
              final user = postController.users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar ?? ''),
                ),
                title: Text('${user.firstname} ${user.lastname}'),
                subtitle: Text('@${user.username}'),
                onTap: () {
                  print(user.username);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherProfile(user: user),
                    ),
                  );
                },
              );
            },
          );
        }
      } else {
        // Hiển thị danh sách post
        if (postController.postuser.isEmpty) {
          return const Center(child: Text('Không tìm thấy kết quả'));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 0.7,
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
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            mediaUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                post.user!.avatar ?? '',
                              ),
                              onBackgroundImageError: (_, __) {},
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${post.user!.firstname} ${post.user!.lastname}' ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          post.description ?? '',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        dummyData
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }

  @override
  void close(BuildContext context, String result) async {
    postController.iswatchpostuser.value = false;
    postController.currentPostUserIndex.value = 0;
    postController.postuser.value = [];
    postController.clearPosts;
    await postController.fetchRandomPost;
    print('SearchDelegate đã bị đóng (pop)');

    super.close(context, result);
  }
}
