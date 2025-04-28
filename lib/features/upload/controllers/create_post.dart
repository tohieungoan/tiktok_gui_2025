import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart'; // Đảm bảo đã thêm package path
import 'package:http_parser/http_parser.dart'; // Import http_parser for MediaType
import 'package:tiktok_app/config/config.dart';
import 'package:tiktok_app/features/auth/controllers/get_accessToken.dart';

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
        print('✅ Đăng bài thành công!');
      } else {
        print('❌ Đăng bài thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Lỗi khi upload bài đăng: $e');
    }
  }
}
