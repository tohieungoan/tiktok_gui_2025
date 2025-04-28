import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/upload/controllers/create_post.dart';
import 'package:video_player/video_player.dart';

class ResultScreen extends StatefulWidget {
  final String mediaPath;

  const ResultScreen({required this.mediaPath, Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late VideoPlayerController _controller;
  bool _isVideo = false;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _isVideo =
        widget.mediaPath.endsWith('.mp4') || widget.mediaPath.endsWith('.mov');

    if (_isVideo) {
      _controller = VideoPlayerController.file(File(widget.mediaPath))
        ..initialize()
            .then((_) {
              setState(() {
                _isControllerInitialized = true;
              });
              _controller.play();
            })
            .catchError((error) {
              print("Lỗi khi khởi tạo video: $error");
            });
    }
  }

  @override
  void dispose() {
    if (_isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Center(
        child: _isVideo
            ? _isControllerInitialized
                ? AspectRatio(
                    aspectRatio: 9 / 16, // Tỷ lệ cho màn hình dọc (portrait)
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator()
            : Image.file(File(widget.mediaPath)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.trang,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Get.back(); // Quay lại trang trước đó với GetX
              },
              child: const Text(
                "Trở Lại",
                style: TextStyle(color: AppColors.den),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dohong,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController _titleController =
                        TextEditingController();
                    return AlertDialog(
                      title: const Text('Tiêu đề video'),
                      content: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: "Nhập tiêu đề tại đây",
                        ),
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.dohong,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            String title = _titleController.text.trim();
                            if (title.isNotEmpty) {
                              // Đóng dialog ngay lập tức
                              Get.back();

                              // Chuyển ngay về trang chủ
                              Get.offAllNamed('/Home');

                              // Hiển thị thông báo tải lên
                              Get.snackbar(
                                "Đang tải lên...",
                                "Vui lòng đợi trong giây lát.",
                                duration: Duration(days: 1),
                                backgroundColor: Colors.black.withOpacity(0.7),
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );

                              try {
                                // Thực hiện upload
                                await ApiPost().uploadPost(
                                  mediaFile: widget.mediaPath,
                                  description: title,
                                );

                                // Ẩn thông báo tải lên và hiển thị thông báo thành công
                                Get.snackbar(
                                  "Upload thành công!",
                                  "Video của bạn đã được đăng tải.",
                                  backgroundColor: Colors.green.withOpacity(0.7),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } catch (e) {
                                // Hiển thị thông báo lỗi
                                Get.snackbar(
                                  "Lỗi tải lên!",
                                  "Đã xảy ra lỗi trong quá trình upload.",
                                  backgroundColor: Colors.red.withOpacity(0.7),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Đăng',
                            style: TextStyle(color: AppColors.trang),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                "Tiếp tục",
                style: TextStyle(color: AppColors.trang),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
