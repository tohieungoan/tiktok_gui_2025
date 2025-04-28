import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/profile/controller/ImageController.dart';
import 'package:tiktok_app/features/profile/controller/UserController.dart';
import 'package:tiktok_app/features/profile/controller/get_current_user_by_token.dart';
import 'package:tiktok_app/services/token_storage.dart';

class AuthService {
  static const String apiUrl = 'auth/login/';
  static const String signUpUrl = 'auth/register/';

  // Sử dụng Get.find để lấy UserController đã được khởi tạo trước đó

  // Đăng nhập qua Facebook
  static Future<Map<String, dynamic>?> signInWithFacebook({
    required BuildContext context,
  }) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        // Kiểm tra người dùng có tồn tại không
        final loginResponse = await _callLoginApi(
          context,
          userData['email'] ?? '',
          userData['id'] ?? '',
        );

        if (loginResponse == null ||
            loginResponse['error'] == 'User not found') {
          // Nếu không tồn tại, đăng ký người dùng
          await signUpWithEmail(
            context: context,
            email: userData['email'] ?? '',
            password:
                userData['id'] ?? '', // Giả sử dùng Facebook ID làm password
            username: userData['name'] ?? 'Facebook User',
          );
          // Sau khi đăng ký, gọi lại đăng nhập
          return await _callLoginApi(
            context,
            userData['email'] ?? '',
            userData['id'] ?? '',
          );
        }
        return loginResponse;
      } else {
        print("❌ Facebook login thất bại: ${result.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facebook Sign-In thất bại')),
        );
      }
    } catch (e) {
      print("❌ Lỗi đăng nhập Facebook: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi đăng nhập Facebook: $e')));
    }
    return null;
  }

  // Đăng nhập qua Google
  static Future<Map<String, dynamic>?> signInWithGoogle({
    required BuildContext context,
  }) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Kiểm tra người dùng có tồn tại không
        final loginResponse = await _callLoginApi(
          context,
          googleUser.email,
          googleUser.id,
        );

        if (loginResponse == null ||
            loginResponse['error'] == 'User not found') {
          // Nếu không tồn tại, đăng ký người dùng
          await signUpWithEmail(
            context: context,
            email: googleUser.email,
            password: googleUser.id, // Giả sử dùng Google ID làm password
            username: googleUser.displayName ?? 'Google User',
          );
          // Sau khi đăng ký, gọi lại đăng nhập
          return await _callLoginApi(context, googleUser.email, googleUser.id);
        }

        return loginResponse;
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Google Sign-In bị hủy')));
      }
    } catch (e) {
      print("❌ Lỗi đăng nhập Google: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi đăng nhập Google: $e')));
    }
    return null;
  }

  // Đăng nhập qua Email
  static Future<Map<String, dynamic>?> signInWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Gọi API đăng nhập với thông tin email và password
      return await _callLoginApi(context, email, password);
    } catch (e) {
      print("❌ Lỗi đăng nhập qua Email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi đăng nhập qua Email: $e')),
      );
    }
    return null;
  }

  // Đăng ký qua Email
  static Future<Map<String, dynamic>?> signUpWithEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Config.baseUrl + signUpUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return await _callLoginApi(context, email, password);
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Lỗi khi đăng ký: Email đã tồn tại trong hệ thống'),
          ),
        );
      } else {
        print("❌ Lỗi từ API: ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đăng ký thất bại')));
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API đăng ký: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi kết nối tới server: $e')));
    }
    return null;
  }

  // Gọi API đăng nhập với thông tin từ Facebook, Google, hoặc Email
  static Future<Map<String, dynamic>?> _callLoginApi(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(Config.baseUrl + apiUrl),
        body: utf8.encode(jsonEncode({'email': email, 'password': password})),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        await TokenStorage.clearRefreshToken();
        String refreshToken = jsonResponse['refresh'];
        await TokenStorage.saveRefreshToken(refreshToken);
        final savedToken = await TokenStorage.getRefreshToken();
        final user = await GetUserByToken.getUserByToken();
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không thể lấy thông tin người dùng')),
          );
          return null;
        }
        final UserController userController = Get.put(
          UserController(),
          permanent: true,
        );

        userController.setUser(user);

        final ImageController imageController = Get.put(
          ImageController(),
          permanent: true,
        );
        if (user.avatar != null) {
          imageController.setAvatarUrl(user.avatar.toString());
        } else {
          imageController.setAvatarUrl(
            "https://i.pinimg.com/236x/74/ff/3d/74ff3d21b7b1c3c9b050cbce04e81f35.jpg",
          );
        }

        Get.offAllNamed('/Home');
        return jsonDecode(response.body); // Trả về dữ liệu từ server
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        // Trả về thông báo lỗi nếu người dùng không tồn tại
        return {'error': 'User not found'};
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đăng nhập thất bại')));
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi kết nối tới server: $e')));
    }
    return null;
  }

  // // Đăng xuất
  // static Future<void> logout() async {
  //   final UserController userController = Get.find<UserController>();
  //   userController.clearUser();
  //   await TokenStorage.clearRefreshToken();
  // }
  // Đăng xuất
static Future<void> logout(BuildContext context) async {
  try {
    final refreshToken = await TokenStorage.getRefreshToken();

    if (refreshToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy refresh token')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(Config.baseUrl + 'auth/logout/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 204) {
      // Logout thành công
      final UserController userController = Get.find<UserController>();
      userController.clearUser();
      await TokenStorage.clearRefreshToken();
      Get.offAllNamed('/Login'); // Quay về trang Login
    } else {
      print('❌ Lỗi logout: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng xuất thất bại: ${response.body}')),
      );
    }
  } catch (e) {
    print("❌ Lỗi khi logout: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lỗi khi kết nối tới server: $e')),
    );
  }
}

}
