import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_app/features/home/screens/Resuilt.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  bool isRecordingMode = false;
  bool isRecording = false;
  bool isPaused = false;

  XFile? _capturedFile;
  XFile? capturedMedia;

  VideoPlayerController? _videoPlayerController;

  Timer? _recordingTimer;
  int _recordingDuration = 0;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      _initCamera();
    } else if (cameraStatus.isPermanentlyDenied || micStatus.isPermanentlyDenied) {
      openAppSettings();
    } else {
      print("Permission denied for camera or microphone");
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        print("No cameras available");
        return;
      }
      _startCamera(_selectedCameraIndex);
    } catch (e) {
      print("Error fetching cameras: $e");
    }
  }

  void _startCamera(int index) {
    _controller?.dispose();
    _controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: true,
    );
    _controller!.initialize().then((_) {
      if (mounted) setState(() {});
    }).catchError((e) {
      print("Error initializing camera: $e");
    });
  }

  void goToNextStep() {
    if (capturedMedia != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(mediaPath: capturedMedia!.path),
        ),
      );
    }
  }

  void _switchCamera() {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _startCamera(_selectedCameraIndex);
  }

  Future<void> startVideoRecording() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        await _controller!.startVideoRecording();
        setState(() {
          isRecording = true;
          isPaused = false;
        });
        _startRecordingTimer();
      } catch (e) {
        print("Lỗi khi bắt đầu quay video: $e");
      }
    }
  }

  Future<void> pauseVideoRecording() async {
    if (_controller != null && _controller!.value.isRecordingVideo) {
      try {
        await _controller!.pauseVideoRecording();
        setState(() {
          isPaused = true;
        });
        _stopRecordingTimer();
      } catch (e) {
        print("Lỗi khi tạm dừng quay video: $e");
      }
    }
  }

  Future<void> resumeVideoRecording() async {
    if (_controller != null && isPaused) {
      try {
        await _controller!.resumeVideoRecording();
        setState(() {
          isPaused = false;
        });
        _startRecordingTimer();
      } catch (e) {
        print("Lỗi khi tiếp tục quay video: $e");
      }
    }
  }

  Future<void> stopVideoRecording() async {
    if (_controller != null && _controller!.value.isRecordingVideo) {
      try {
        XFile file = await _controller!.stopVideoRecording();
        _stopRecordingTimer();

        Directory appDirectory = await getApplicationDocumentsDirectory();
        String newPath = '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
        File tempFile = File(file.path);
        await tempFile.copy(newPath);

        setState(() {
          isRecording = false;
          isPaused = false;
          capturedMedia = XFile(newPath);
        });

        print("Video đã lưu tại: $newPath");
        goToNextStep();
      } catch (e) {
        print("Lỗi khi dừng quay video: $e");
      }
    }
  }

  void _startRecordingTimer() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  void _resetState() {
    setState(() {
      _capturedFile = null;
      _videoPlayerController?.dispose();
      _videoPlayerController = null;
      _recordingDuration = 0;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _videoPlayerController?.dispose();
    _stopRecordingTimer();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (!_controller!.value.isInitialized) return;
    try {
      final XFile file = await _controller!.takePicture();
      setState(() {
        _capturedFile = file;
        capturedMedia = file;
      });
      goToNextStep();
    } catch (e) {
      print("Error taking photo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          if (_capturedFile == null)
            CameraPreview(_controller!)
          else if (!isRecordingMode)
            Positioned.fill(
              child: Image.file(File(_capturedFile!.path), fit: BoxFit.cover),
            )
          else if (_videoPlayerController != null &&
              _videoPlayerController!.value.isInitialized)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              ),
            ),

          if (isRecording)
            Positioned(
              bottom: 140,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Recording: ${_recordingDuration}s",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),

          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: _switchCamera,
              icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 30),
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () {
                setState(() {
                  isRecordingMode = !isRecordingMode;
                  isRecording = false;
                  _resetState();
                });
              },
              child: Text(
                isRecordingMode ? 'Mode: Video' : 'Mode: Photo',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (isRecordingMode) {
                    if (isRecording) {
                      if (isPaused) {
                        resumeVideoRecording();
                      } else {
                        pauseVideoRecording();
                      }
                    } else {
                      startVideoRecording();
                    }
                  } else {
                    _takePhoto();
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isRecordingMode
                        ? (isRecording ? Colors.red : Colors.white)
                        : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Icon(
                    isRecording
                        ? (isPaused ? Icons.play_arrow : Icons.pause)
                        : Icons.circle,
                    color: isRecording ? Colors.white : Colors.black,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),

          if (isPaused)
            Positioned(
              bottom: 40,
              right: 20,
              child: TextButton(
                onPressed: stopVideoRecording,
                child: const Text('Stop', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
        ],
      ),
    );
  }
}

// Dummy ResultScreen class (bạn có thể thay thế bằng màn hình thật)
