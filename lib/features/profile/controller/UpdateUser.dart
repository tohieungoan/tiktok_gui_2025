import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';
import 'package:tiktok_app/features/profile/controller/ImageController.dart';
import 'package:tiktok_app/models/User.dart';
import 'package:http_parser/http_parser.dart'; // dùng cho contentType

class UpdateUserController {
  static const String url = "user/";

  static Future<Userapp?> updateUserapi({
    String? email,
    String? username,
    String? firstname,
    String? lastname,
    String? password,
    String? phone,
    String? birthdate,
    String? gender,
    String? bio,
    String? avatarPath, // Đường dẫn tới file ảnh trên thiết bị
  }) async {
    final uri = Uri.parse(Config.baseUrl + url);

    // Lấy access token
    String? accessToken = await getAcessService.getAccessToken();
    if (accessToken == null) {
      print("Không tìm thấy access token!");
      throw Exception("Không tìm thấy access token.");
    }

    final request = http.MultipartRequest('PATCH', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Thêm các trường văn bản (nếu có)
    if (email != null) request.fields['email'] = email;
    if (username != null) request.fields['username'] = username;
    if (firstname != null) request.fields['firstname'] = firstname;
    if (lastname != null) request.fields['lastname'] = lastname;
    if (password != null) request.fields['password'] = password;
    if (phone != null) request.fields['phone'] = phone;
    if (birthdate != null) request.fields['birthdate'] = birthdate;
    if (gender != null) request.fields['gender'] = gender;
    if (bio != null) request.fields['bio'] = bio;

    // Thêm file avatar nếu có
    if (avatarPath != null && avatarPath.isNotEmpty) {
      final file = File(avatarPath);
      if (await file.exists()) {
        final mimeType = 'image/${avatarPath.split('.').last}';
        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar_file',
            avatarPath,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else {
        print("Không tìm thấy file avatar tại đường dẫn: $avatarPath");
      }
    }
    // Gửi yêu cầu
    final response = await request.send();

    // Đọc stream MỘT lần duy nhất
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(responseBody);
      final avatarUrl = jsonResponse['user']['avatar'];
      final imageController = Get.find<ImageController>();
      imageController.setAvatarUrl(avatarUrl);
      imageController.clearSelectedImage();
      Get.back(); 

      Get.snackbar(
        "Upload thành công!",
        "Thông tin của bạn đã được cập nhật.",
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return Userapp.fromJson(jsonDecode(responseBody));
} else {
  final imageController = Get.find<ImageController>();
  imageController.clearSelectedImage();

  // Gọi snackbar sau frame để đảm bảo context hợp lệ
  WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.back(); 

    Get.snackbar(
      "Lỗi tải lên!",
      "Nội dung không phù hợp hoặc sai định dạng.\n$responseBody",
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  });
      Get.back(); 

  // Trả về null chứ không phải Get.snackbar
  return null;
}
  }
  
  }