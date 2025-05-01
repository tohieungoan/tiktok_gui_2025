import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/features/home/controllers/ApiFollow.dart';
import 'package:tiktok_app/features/home/controllers/CommentController.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';
import 'package:tiktok_app/features/profile/controller/ImageController.dart';
import 'package:tiktok_app/features/profile/controller/UserController.dart';
import 'package:tiktok_app/features/profile/controller/get_current_user_by_token.dart';

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  final UserController userController = Get.put(
    UserController(),
    permanent: true,
  );
  final PostController postController = Get.put(
    PostController(),
    permanent: true,
  );
  final CommentController commentController = Get.put(
    CommentController(),
    permanent: true,
  );
  final ImageController imageController = Get.put(
    ImageController(),
    permanent: true,
  );

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    try {
      final user = await GetUserByToken.getUserByToken();
      if (!mounted) return;

      if (user != null) {
        userController.setUser(user);
        if (user.avatar != null) {
          imageController.setAvatarUrl(user.avatar.toString());
        } else {
          imageController.setAvatarUrl(
            "https://i.pinimg.com/236x/74/ff/3d/74ff3d21b7b1c3c9b050cbce04e81f35.jpg",
          );
        }
        await postController.fetchRandomPost();
        await ApiFollow.GetFollower(context: context, iduser: user.id.toString());
        await ApiFollow.GetFollowing(context: context, iduser: user.id.toString());
        Get.offAllNamed('/Home');
      } else {
        Get.offAllNamed('/');
      }
    } catch (e) {
      if (mounted) Get.offAllNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
