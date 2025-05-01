import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tiktok_app/features/home/controllers/ApiFollow.dart';
import 'package:tiktok_app/features/home/controllers/ApiSearch.dart';
import 'package:tiktok_app/features/upload/controllers/create_post.dart';
import 'package:tiktok_app/models/Post.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';

import 'package:tiktok_app/models/User.dart';

class PostController extends GetxController {
  RxList<Post> posts = <Post>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentPostIndex = 0.obs;
  RxInt currentPostUserIndex = 0.obs;
  RxList<Userapp> users = <Userapp>[].obs;
  RxBool islike = false.obs;
  RxBool isFollow = false.obs;
  RxBool iswatchpostuser = false.obs;
  RxList<Post> postuser = <Post>[].obs;
  RxList<Post> mypost = <Post>[].obs;
  String convertHttpToHttps(String url) {
    if (url.startsWith("http://")) {
      return url.replaceFirst("http://", "https://");
    }
    return url;
  }

  // Kiểm tra và preload video
  Future<File> preloadVideo(String url) async {
    url = convertHttpToHttps(url);

    var fileInfo = await DefaultCacheManager().getFileFromCache(url);
    if (fileInfo != null) {
      return fileInfo.file;
    } else {
      try {
        File file = await DefaultCacheManager().getSingleFile(url);
        return file;
      } catch (e) {
        rethrow;
      }
    }
  }

  // Hàm tải các bài post và preload video
  Future<void> fetchRandomPost() async {
    isLoading.value = true;
    try {
      final List<Post> fetchedPosts = await ApiPost.getRandomPost();

      for (var post in fetchedPosts) {
        posts.add(post);

        // Lưu video vào cache ngay sau khi tải bài post
        if (post.media != null) {
          preloadVideo(post.media!)
              .then((file) {
                print("Video đã được tải và lưu vào cache tại: ${file.path}");
              })
              .catchError((e) {
                print("Lỗi khi tải video: $e");
              });
        }
      }
    } catch (e) {
      print("Lỗi khi tải các bài post: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPostUser(String Iduser) async {
    isLoading.value = true;
    try {
      postuser.clear();
      final List<Post> fetchedPosts = await ApiPost.getPostfromUser(Iduser);

      for (var post in fetchedPosts) {
        postuser.add(post);
      }
    } catch (e) {
      print("Lỗi khi tải các bài post: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPostsearch(String search) async {
    isLoading.value = true;
    try {
      postuser.clear();
      final List<Post> fetchedPosts = await ApiSearch.SearchPost(search);

      for (var post in fetchedPosts) {
        postuser.add(post);
      }
    } catch (e) {
      print("Lỗi khi tải các bài post: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserSearch(String search) async {
    isLoading.value = true;
    try {
      users.clear();
      final List<Userapp> fetchedUsers = await ApiSearch.SearchUser(search);

      for (var user in fetchedUsers) {
        users.add(user);
      }
    } catch (e) {
      print("Lỗi khi tải các bài post: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyPost(String Iduser) async {
    isLoading.value = true;
    try {
      mypost.clear();
      final List<Post> fetchedPosts = await ApiPost.getPostfromUser(Iduser);

      for (var post in fetchedPosts) {
        mypost.add(post);
      }
    } catch (e) {
      print("Lỗi khi tải các bài post: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm tăng hoặc giảm likes count
  void toggleLike(Post post) {
    post.likesCount.value = (post.likesCount.value ?? 0) + 1;
    update(); // Đảm bảo rằng widget được cập nhật
  }

  void decreaseLike(Post post) {
    if (post.likesCount.value != null && post.likesCount.value! > 0) {
      post.likesCount.value = post.likesCount.value! - 1;
      update(); // Đảm bảo rằng widget được cập nhật
    }
  }

  // Hàm tăng hoặc giảm comment count
  void toggleComment(Post post) {
    post.commentsCount.value = (post.commentsCount.value ?? 0) + 1;
    update(); // Đảm bảo rằng widget được cập nhật
  }

  void decreaseComment(Post post) {
    if (post.commentsCount.value != null && post.commentsCount.value! > 0) {
      post.commentsCount.value = post.commentsCount.value! - 1;
      update(); // Đảm bảo rằng widget được cập nhật
    }
  }

  // Hàm tăng hoặc giảm shares count
  void toggleShare(Post post) {
    post.sharesCount.value = (post.sharesCount.value ?? 0) + 1;
    update(); // Đảm bảo rằng widget được cập nhật
  }

  void decreaseShare(Post post) {
    if (post.sharesCount.value != null && post.sharesCount.value! > 0) {
      post.sharesCount.value = post.sharesCount.value! - 1;
      update(); // Đảm bảo rằng widget được cập nhật
    }
  }

  Future<void> checkFollowing(Post post) async {
    await ApiFollow.checkFollow(
      context: Get.context!,
      iduser: post.user!.id.toString(),
    );
  }

  void clearPosts() {
    posts.clear();
    if (currentPostIndex.value >= posts.length) {
      currentPostIndex.value = 0;
    }
  }
}
