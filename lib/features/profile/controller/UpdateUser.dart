import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';
import 'package:tiktok_app/models/User.dart';

class UpdateUserController {
  static const String url = "user/";

  static Future<Userapp?> updateUserapi({
    required String? id,
    String? email,
    String? username,
    String? firstname,
    String? lastname,
    String? password,
    String? phone,
    String? birthdate,
    String? gender,
    String? bio,
    String? avatar,
  }) async {
    final Map<String, dynamic> body = {};
 
    if (email != null) body['email'] = email;
    if (username != null) body['username'] = username;
    if (firstname != null) body['firstname'] = firstname;
    if (lastname != null) body['lastname'] = lastname;
    if (password != null) body['password'] = password;
    if (phone != null) body['phone'] = phone;

    if (birthdate != null) body['birthdate'] = birthdate;

    if (gender != null) body['gender'] = gender;
    if (bio != null) body['bio'] = bio;
    if (avatar != null) body['avatar'] = avatar;

    print(
      "Body data: ${jsonEncode(body)}",
    ); // Kiểm tra xem body có được mã hóa thành chuỗi JSON đúng

    // Lấy access token từ service
    String? accessToken = await getAcessService.getAccessToken();
    if (accessToken == null) {
      print("Không tìm thấy access token!");
      throw Exception("Không tìm thấy access token.");
    }
    print("Access token: $accessToken");

    final response = await http.patch(
      Uri.parse(Config.baseUrl + '$url'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("Cập nhật thành công: ${response.body}");
      return Userapp.fromJson(jsonDecode(response.body));
    } else {
      print("Cập nhật thất bại: ${response.body}");
      print("Mã lỗi: ${response.statusCode}");
      throw Exception('Cập nhật thất bại: ${response.body}');
    }
  }
}
