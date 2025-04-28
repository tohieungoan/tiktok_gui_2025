import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/features/profile/controller/ImageController.dart';
import 'package:tiktok_app/features/upload/controllers/gallery.dart';

class AvatarWidget extends StatelessWidget {
  final ImageController imageController = Get.find<ImageController>();

  AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String? avatarUrl = imageController.avatarUrl.value;
      print(avatarUrl);
      XFile? selectedImage = imageController.selectedImage.value;
      return Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  selectedImage != null
                      ? FileImage(File(selectedImage.path))
                      : (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl)
                      : NetworkImage(
                        'https://i.pinimg.com/236x/74/ff/3d/74ff3d21b7b1c3c9b050cbce04e81f35.jpg',
                      ), // Avatar mặc địnhảnh
            ),
            const EditIconButton(),
          ],
        ),
      );
    });
  }
}

class EditIconButton extends StatelessWidget {
  const EditIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.penToSquare,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () async {
            // Chọn ảnh từ gallery
            XFile? image = await GetMediaGallery().pickImageFromGallery();
            if (image != null) {
              // Cập nhật ảnh đã chọn vào ImageController
              Get.find<ImageController>().setSelectedImage(image);
            }
          },
        ),
      ),
    );
  }
}
