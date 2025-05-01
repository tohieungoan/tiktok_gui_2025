import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart'; // Đảm bảo đã thêm package path
import 'package:http_parser/http_parser.dart'; // Import http_parser for MediaType
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';
import 'package:tiktok_app/models/Post.dart';

class ApiPost {
  Future<void> uploadPost({
    required String mediaFile,
    required String description,
  }) async {
    final url = Uri.parse('${Config.baseUrl}post/');

    try {
      var request = http.MultipartRequest('POST', url);

      request.fields['description'] = description;

      String fileExtension = extension(mediaFile).toLowerCase();

      MediaType mediaType;
      if (fileExtension == '.jpg' || fileExtension == '.jpeg') {
        mediaType = MediaType('image', 'jpeg');
      } else if (fileExtension == '.png') {
        mediaType = MediaType('image', 'png');
      } else if (fileExtension == '.mp4') {
        mediaType = MediaType('video', 'mp4');
      } else {
        throw Exception('Loại tệp không hỗ trợ');
      }

      // Thêm tệp vào request với MIME type phù hợp
      request.files.add(
        await http.MultipartFile.fromPath(
          'media_file',
          mediaFile,
          filename: basename(mediaFile),
          contentType: mediaType,
        ),
      );

      // Lấy accessToken
      String? accessToken = await getAcessService.getAccessToken();
      if (accessToken != null) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        print('❌ Không có accessToken');
      }

      // Gửi request và nhận phản hồi
      var streamedResponse = await request.send();
      print(basename(mediaFile));
      var response = await http.Response.fromStream(streamedResponse);

      // Kiểm tra status code và xử lý phản hồi
      if (response.statusCode == 201) {
        Get.snackbar(
          "Upload thành công!",
          "Video của bạn đã được đăng tải.",
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Lỗi tải lên!",
          "Nội dung không phù hợp.",
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Lỗi tải lên!",
        "Đã xảy ra lỗi trong quá trình upload.",
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  static Future<List<Post>> getRandomPost() async {
    try {
      String? accessToken = await getAcessService.getAccessToken();
      if (accessToken == null) {
        print("Không tìm thấy access token!");
        return [];
      }

      final response = await http.get(
        Uri.parse(Config.baseUrl + "post/random/"),
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
        print("Số lượng bài đăng nhận được: ${posts.length}");
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


    static Future<List<Post>> getPostfromUser(
    String iduser,
    ) async {
    try {
      String? accessToken = await getAcessService.getAccessToken();
      if (accessToken == null) {
        print("Không tìm thấy access token!");
        return [];
      }

      final response = await http.get(
        Uri.parse(Config.baseUrl + "\post/user/$iduser/"),
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
}
