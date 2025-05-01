  import 'dart:convert';

  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:tiktok_app/config/config.dart';
  import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';
  import 'package:tiktok_app/models/User.dart';

  class GetUserByToken {
    static const String Url = "user/";
    static Future<Userapp?> getUserByToken() async {
      try {
        String? accessToken = await getAcessService.getAccessToken();
        if (accessToken == null) {
          print("Không tìm thấy access token!");
          return null;
        }
        final response = await http.get(
          Uri.parse(Config.baseUrl + Url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );
        if (response.statusCode == 200) {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          Userapp user = Userapp.fromJson(responseData);
          print("Thông tin người dùng: ${user.toJson()}");
          return user;
        } else {
          print("Lỗi khi lấy thông tin người dùng: ${response.statusCode}");
          print("Response body: ${response.body}");
          return null;
        }
      } catch (e) {
        print("Lỗi khi lấy thông tin người dùng: $e");
        return null;
      }
    }
static Future<Userapp?> getUserById(String iduser) async {
  try {
    String? accessToken = await getAcessService.getAccessToken();
    if (accessToken == null) {
      print("Không tìm thấy access token!");
      return null;
    }

    final response = await http.get(
      Uri.parse("${Config.baseUrl}${Url}$iduser/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      Userapp user = Userapp.fromJson(responseData);
      print("Thông tin người dùng: ${user.toJson()}");
      return user;
    } else {
      print("Lỗi khi lấy thông tin người dùng theo ID: ${response.statusCode}");
      print("Response body: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Lỗi khi lấy thông tin người dùng theo ID: $e");
    return null;
  }
}

  }
