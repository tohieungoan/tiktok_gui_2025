import 'dart:io';

import 'package:flutter/material.dart';
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
    // Kiểm tra đuôi file để xác định xem là video hay ảnh
    _isVideo =
        widget.mediaPath.endsWith('.mp4') || widget.mediaPath.endsWith('.mov');

    if (_isVideo) {
      _controller = VideoPlayerController.file(File(widget.mediaPath))
        ..initialize().then((_) {
          setState(() {
            _isControllerInitialized = true;
          });
          _controller.play();
        }).catchError((error) {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: _isVideo
            ? _isControllerInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator() // Chờ video tải xong
            : Image.file(
                File(widget.mediaPath)), // Nếu không phải video, hiển thị ảnh
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Trở Lại"),
            ),
            ElevatedButton(
              onPressed: () {
           
              },
              child: const Text("Tiếp tục"),
            ),
          ],
        ),
      ),
    );
  }
}
