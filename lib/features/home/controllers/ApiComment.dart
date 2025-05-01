import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';
import 'package:tiktok_app/models/Comment.dart';
import 'package:tiktok_app/models/Post.dart';

class ApiComments {
  static Future<Map<String, dynamic>?> CreateComment({
    required BuildContext context,
    required String idpost,
    String? parent_comment,
    required Post currentPost,
    required String content,
  }) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();

      final response = await http.post(
        Uri.parse(Config.baseUrl + 'comment/'),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'post': idpost,
          'parent_comment': parent_comment,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        print('Comment created successfully!');
        print('Response: ${response.body}');
        final PostController postController = Get.find<PostController>();
        postController.toggleComment(currentPost);
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
     static Future<List<Comment>> GetComment({
    required BuildContext context,
    required String idpost,
  }) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();

      final response = await http.get(
        Uri.parse(Config.baseUrl + 'comment/posts/$idpost/comments/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
  
        if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        List<Comment> comments =
            responseData.map((json) => Comment.fromJson(json)).toList();
        return comments;
      } else {
        _showError(context, " ádsadsadas ");
      }
    } catch (e) {
      _showError(context,"sdadasadas");
    }
    return [];
  }

  // Show error message
  static void _showError(BuildContext context, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  }
}