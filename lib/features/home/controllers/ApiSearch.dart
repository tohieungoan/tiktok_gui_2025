import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';
import 'package:tiktok_app/models/Post.dart';
import 'package:tiktok_app/models/User.dart';  // <-- import thêm model User

class ApiSearch {
  static Future<List<Post>> SearchPost(String search) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();
      if (accessToken == null) {
        print("Không tìm thấy access token!");
        return [];
      }

      final response = await http.get(
        Uri.parse(Config.baseUrl + "post/search/?query=$search"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        List<Post> posts =
            responseData.map((json) => Post.fromJson(json)).toList();
        return posts;
      } else {
        print("Lỗi khi lấy thông tin bài đăng: ${response.statusCode}");
        print("Response body: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin bài đăng: $e");
      return [];
    }
  }

  static Future<List<Userapp>> SearchUser(String username) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();
      if (accessToken == null) {
        print("Không tìm thấy access token!");
        return [];
      }

      final response = await http.get(
        Uri.parse(Config.baseUrl + 'user/search/?username=$username'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
print("url: ${Config.baseUrl + 'user/search/?username=$username'}");
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        List<Userapp> users =
            responseData.map((json) => Userapp.fromJson(json)).toList();
          
        return users;
      } else {
        print("Lỗi khi lấy thông tin người dùng: ${response.statusCode}");
        print("Response body: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin người dùng: $e");
      return [];
    }
  }
}
