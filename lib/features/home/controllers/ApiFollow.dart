import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';
import 'package:tiktok_app/features/profile/controller/UserController.dart';

class ApiFollow {
  static Future<Map<String, dynamic>?> checkFollow({
    required BuildContext context,
    required String iduser,
  }) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();

      final response = await http.get(
        Uri.parse(Config.baseUrl + 'follow/check-follow/$iduser/'),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        PostController postController = Get.find<PostController>();
        final data = jsonDecode(response.body);
        postController.isFollow.value =
            data['is_following']; // Gán giá trị đúng
        return data;
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Yêu cầu không hợp lệ.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi server: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi kết nối tới server: $e')));
    }
    return null;
  }

  static Future<Map<String, dynamic>?> createFollow({
    required BuildContext context,
    required String iduser,
  }) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();

      final response = await http.post(
        Uri.parse(Config.baseUrl + 'follow/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'followed': iduser}),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      PostController postController = Get.find<PostController>();

      if (response.statusCode == 201) {
        postController.isFollow.value = true;
        UserController userController = Get.find<UserController>();
        userController.Following.value += 1; // Tăng số lượng người theo dõi
        Get.snackbar(
          'Thành công',
          'Đã theo dõi thành công',
          snackPosition: SnackPosition.BOTTOM,
        );
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'Lỗi',
          'Bạn không thể follow chính mình',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bạn chưa đăng nhập')));
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn đã theo dõi người này rồi')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi server: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi kết nối tới server: $e')));
    }
    return null;
  }

  static Future<Map<String, dynamic>?> unFollow({
    required BuildContext context,
    required String iduser,
  }) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();

      final response = await http.delete(
        Uri.parse(Config.baseUrl + 'follow/unfollow/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'followed': iduser}), // Đã sửa đúng biến
      );
      PostController postController = Get.find<PostController>();
      if (response.statusCode == 204) {
        postController.isFollow.value = false;
        UserController userController = Get.find<UserController>();
        userController.Following.value -= 1; // Giảm số lượng người theo dõi
        Get.snackbar(
          'Thành công',
          'Đã hủy theo dõi thành công',
          snackPosition: SnackPosition.BOTTOM,
        );
        return {};
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Yêu cầu không hợp lệ.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi server: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi kết nối tới server: $e')));
    }
    return null;
  }

  static Future<String?> GetFollower({
    required BuildContext context,
    required String iduser,
  }) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();

      final response = await http.get(
        Uri.parse(Config.baseUrl + 'follow/followers/'),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        UserController userController = Get.find<UserController>();

        final data = jsonDecode(response.body);
        userController.Follower.value = data.length;
        print("Follower count: ${userController.Follower.value}");
        return response.body;
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Yêu cầu không hợp lệ.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi server: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi kết nối tới server: $e')));
    }
    return null;
  }

  static Future<String?> GetFollowing({
  required BuildContext context,
  required String iduser,
}) async {
  try {
    String? accessToken = await getAcessService.getAccessToken();

    final response = await http.get(
      Uri.parse(Config.baseUrl + 'follow/following/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      UserController userController = Get.find<UserController>();

      final data = jsonDecode(response.body);
      print("Data returned: $data"); // Kiểm tra dữ liệu trả về

      // Kiểm tra nếu dữ liệu không rỗng và lấy số lượng
      if (data.isNotEmpty) {
        userController.Following.value = data.length;
        print("Following count: ${userController.Following.value}");
      } else {
        userController.Following.value = 0;
        print("No following data.");
      }

      return response.body;
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Yêu cầu không hợp lệ.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi server: ${response.statusCode}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Lỗi khi kết nối tới server: $e')));
  }
  return null;
}

}
