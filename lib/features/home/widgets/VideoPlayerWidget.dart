// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerWidget extends StatefulWidget {
//   final String mediaUrl;

//   const VideoPlayerWidget( {Key? key, required this.mediaUrl}) : super(key: key);

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _videoController;

//   // Hàm chuyển HTTP thành HTTPS nếu cần thiết
//   String convertHttpToHttps(String url) {
//     if (url.startsWith("http://")) {
//       return url.replaceFirst("http://", "https://");
//     }
//     return url; // Nếu đã là https thì giữ nguyên
//   }

//   // Hàm dựng video trực tiếp
//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.network(convertHttpToHttps(widget.mediaUrl))
//       ..initialize().then((_) {
//         // Bắt đầu phát video ngay khi có thể
//         setState(() {});
//         _videoController.play();
//       }).catchError((e) {
//         print("Lỗi khi tải video: $e");
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _videoController.value.isInitialized
//         ? SizedBox.expand(
//             child: VideoPlayer(_videoController),
//           )
//         : SizedBox(); // Không hiển thị gì khi video chưa được tải
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _videoController.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:tiktok_app/core/widgets/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';

class VideoPlayerWidget extends StatefulWidget {
  final String currentMediaUrl;

  const VideoPlayerWidget({
    Key? key,
    required this.currentMediaUrl,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  late Future<File> _cachedFile;
  bool _isPlaying = true;
  double _currentPosition = 0.0;

  // Hàm chuyển HTTP thành HTTPS nếu cần thiết
  String convertHttpToHttps(String url) {
    if (url.startsWith("http://")) {
      return url.replaceFirst("http://", "https://");
    }
    return url; // Nếu đã là https thì giữ nguyên
  }

  // Kiểm tra và preload video
  Future<File> preloadVideo(String url) async {
    // Đảm bảo URL là HTTPS
    url = convertHttpToHttps(url);

    // Kiểm tra video có trong bộ nhớ cache không
    var fileInfo = await DefaultCacheManager().getFileFromCache(url);
    if (fileInfo != null) {
      showSuccessToast("Video có trong cache");
      print("Video đã có trong cache: ${fileInfo.file.path}");
      return fileInfo.file;
    } else {
      showErrorToast("Video chưa có trong cache");
      try {
        // Tải video về và lưu vào cache
        File file = await DefaultCacheManager().getSingleFile(url);
        showSuccessToast("Video đã tải và lưu vào cache");
        print("Video đã lưu vào cache tại: ${file.path}");
        return file;
      } catch (e) {
        showErrorToast("Lỗi khi tải video: $e");
        rethrow;
      }
    }
  }

  // Xóa video cache sau 5 phút
  void _removeCachedVideoAfterDelay(String url) {
    Future.delayed(Duration(minutes: 5), () async {
      await DefaultCacheManager().removeFile(url);
      print("Video cache đã bị xóa sau 5 phút: $url");
    });
  }

  // Hàm dựng video trực tiếp
  @override
  void initState() {
    super.initState();
    print("Đường dẫn video hiện tại: ${widget.currentMediaUrl}");

    // Preload video tiếp theo

    // Tải video hiện tại và phát
    _cachedFile = preloadVideo(widget.currentMediaUrl);
    _cachedFile.then((file) {
      _videoController = VideoPlayerController.file(file)
        ..initialize()
            .then((_) {
              setState(() {});
              _videoController.play();
              _videoController.addListener(() {
                setState(() {
                  _currentPosition =
                      _videoController.value.position.inSeconds.toDouble();
                });
              });
            })
            .catchError((e) {
              print("Lỗi khi tải video: $e");
            });

      // Xóa video cache sau 5 phút
      _removeCachedVideoAfterDelay(widget.currentMediaUrl);
    });
  }

  // Hàm dừng hoặc phát video khi bấm vào giữa màn hình
  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  // Hàm tua video
  void _seekTo(double value) {
    final position = Duration(seconds: value.toInt());
    _videoController.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _cachedFile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return GestureDetector(
            onTap: _togglePlayPause, // Bấm vào giữa màn hình để dừng hoặc phát
            child: Stack(
              alignment: Alignment.center,
              children: [
                _videoController.value.isInitialized
                    ? SizedBox.expand(child: VideoPlayer(_videoController))
                    : Center(child: CircularProgressIndicator()),
                if (_isPlaying == false)
                  Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Slider(
                        value: _currentPosition,
                        min: 0.0,
                        max:
                            _videoController.value.duration.inSeconds
                                .toDouble(),
                        onChanged: (value) {
                          _seekTo(value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(
                              Duration(seconds: _currentPosition.toInt()),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatDuration(_videoController.value.duration),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text("Lỗi khi tải video"));
        }
      },
    );
  }

  // Hàm chuyển đổi thời gian sang định dạng hh:mm:ss
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return "${hours > 9 ? hours : '0$hours'}:${minutes > 9 ? minutes : '0$minutes'}:${seconds > 9 ? seconds : '0$seconds'}";
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}
