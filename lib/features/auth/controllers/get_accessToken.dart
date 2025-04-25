import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/services/token_storage.dart';

class getAcessService {
  static const String Url = "token/refresh/";
    static Future<String?> getAccessToken() async {
    try {
      String? refreshToken = await TokenStorage.getRefreshToken();

      if (refreshToken == null) {
        print("Không tìm thấy refresh token!");
        return null;
      }
      final Map<String, String> body = {
        "refresh": refreshToken,
      };

      final response = await http.post(
        Uri.parse(Config.baseUrl + Url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String accessToken = responseData['access'];
        return accessToken;
      } else {
        print("Lỗi khi lấy access token: ${response.statusCode}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Lỗi khi lấy access token: $e");
      return null;
    }
  }
}
