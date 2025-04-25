import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _refreshTokenKey = 'refresh_token';
  static Future<void> saveRefreshToken(String refreshToken) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenKey, refreshToken);
      print("Refresh token đã được lưu!");
    } catch (e) {
      print("Lỗi khi lưu refresh token: $e");
    }
  }
  static Future<String?> getRefreshToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      print("Lỗi khi lấy refresh token: $e");
      return null;
    }
  }
  static Future<void> clearRefreshToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_refreshTokenKey);
      print("Refresh token đã bị xóa!");
    } catch (e) {
      print("Lỗi khi xóa refresh token: $e");
    }
  }
}
