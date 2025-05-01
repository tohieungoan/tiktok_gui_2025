import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';

class ApiLike {
  static Future<Map<String, dynamic>?> createLike({
    required BuildContext context,
    required String iduser,
    required String idpost,
  }) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();

      final response = await http.post(
        Uri.parse(Config.baseUrl + 'like/11/$iduser/like/'),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'target_id': idpost, 'target_type': 'post'}),
      );

      if (response.statusCode == 201) {
        final PostController postController = Get.find<PostController>();
        
        return jsonDecode(response.body);
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

  static Future<Map<String, dynamic>?> deleteLike({
    required BuildContext context,
    required String idpost,
  }) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();

      final response = await http.delete(
        Uri.parse(Config.baseUrl + 'like/post/$idpost/like/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print("url: ${Config.baseUrl + 'like/post/$idpost/like/'}");
      if (response.statusCode == 204) {
        // 204 No Content: Không có nội dung trả về => return null hoặc empty map
        return {}; // hoặc return null nếu bạn không cần gì
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
