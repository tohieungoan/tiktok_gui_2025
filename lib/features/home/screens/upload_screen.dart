 import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

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
  bool isPaused = false; // Track if recording is paused

  XFile? _capturedFile;
  VideoPlayerController? _videoPlayerController;

  Timer? _recordingTimer;
  int _recordingDuration = 0; // Duration in seconds

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus micStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      _initCamera();
    } else if (cameraStatus.isPermanentlyDenied ||
        micStatus.isPermanentlyDenied) {
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
    _controller!
        .initialize()
        .then((_) {
          if (mounted) setState(() {});
        })
        .catchError((e) {
          print("Error initializing camera: $e");
        });
  }

  void _switchCamera() {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _startCamera(_selectedCameraIndex);
  }

  Future<void> _startStopRecording() async {
    if (!_controller!.value.isInitialized) return;

    try {
      if (isRecording) {
        if (isPaused) {
          // Resume recording by re-initiating video recording
          await _controller!.startVideoRecording();
          _startRecordingTimer();
          setState(() {
            isPaused = false;
          });
        } else {
          // Pause recording
          await _controller!.stopVideoRecording();
          _stopRecordingTimer();
          setState(() {
            isPaused = true;
          });
        }
      } else {
        // Start recording
        await _controller!.prepareForVideoRecording();
        await _controller!.startVideoRecording();
        _startRecordingTimer();
        setState(() {
          isRecording = true;
          isPaused = false;
        });
      }
    } catch (e) {
      print("Error recording video: $e");
    }
  }

Future<void> _stopRecording() async {
  if (isRecording && !isPaused) {
    try {
      // Stop video recording
      final XFile videoFile = await _controller!.stopVideoRecording();
      _stopRecordingTimer();

      setState(() {
        isRecording = false;
        isPaused = false;
        _capturedFile = videoFile; // Save the recorded video file
      });

      // Show the video player
      _showVideoPlayer();

    } catch (e) {
      print("Error stopping video recording: $e");
    }
  }
}

  void _startRecordingTimer() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

void _showVideoPlayer() async {
  if (_capturedFile == null) return;

  // Initialize video player controller
  _videoPlayerController = VideoPlayerController.file(
    File(_capturedFile!.path),
  );

  await _videoPlayerController!.initialize();
  setState(() {});

  // Play the video
  await _videoPlayerController!.play();
}

  @override
  void dispose() {
    _controller?.dispose();
    _videoPlayerController?.dispose();
    _stopRecordingTimer();
    super.dispose();
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

          // Timer during recording
          if (isRecording)
            Positioned(
              top: 40,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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

          // Switch camera button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: _switchCamera,
              icon: const Icon(
                Icons.cameraswitch,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          // Toggle mode button
          Positioned(
            top: 40,
            left: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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

          // Capture/Record button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (isRecordingMode) {
                    _startStopRecording();
                  } else {
                    _takePhoto();
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        isRecordingMode
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

          // Stop recording button when paused
          if (isPaused)
            Positioned(
              bottom: 40,
              right: 20,
              child: GestureDetector(
                onTap: _stopRecording,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: const Icon(Icons.stop, color: Colors.white, size: 40),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    if (!_controller!.value.isInitialized) return;
    try {
      final XFile file = await _controller!.takePicture();
      setState(() {
        _capturedFile = file;
      });
    } catch (e) {
      print("Error taking photo: $e");
    }
  }
}
