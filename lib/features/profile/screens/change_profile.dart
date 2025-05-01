import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/profile/controller/ImageController.dart';
import 'package:tiktok_app/features/profile/controller/UpdateUser.dart';
import 'package:tiktok_app/features/profile/controller/UserController.dart';
import 'package:tiktok_app/features/upload/controllers/gallery.dart';
import 'package:tiktok_app/models/User.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final UserController userController = Get.find<UserController>();
  final ImageController imageController = Get.find<ImageController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  String selectedGender = 'Khác';
  DateTime? selectedBirthday;

  @override
  Widget build(BuildContext context) {
    final user = userController.user.value;

    final fullName = (user?.firstname ?? '') + ' ' + (user?.lastname ?? '');
    final nameParts = fullName.trim().split(RegExp(r'\s+'));
    final firstName = nameParts.sublist(0, nameParts.length - 1).join(' ');
    final lastName = nameParts.isNotEmpty ? nameParts.last : '';

    nameController.text = firstName + " " + lastName;
    usernameController.text = user?.username ?? '';
    bioController.text = user?.bio ?? '';
    phoneController.text = user?.phone ?? '';
    birthdayController.text = user?.birthdate ?? '';
    selectedGender = user?.gender ?? 'Khác';

    if (user?.birthdate != null) {
      selectedBirthday = DateTime.tryParse(user!.birthdate!);
    }

    return Scaffold(
      backgroundColor: AppColors.trang,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chỉnh sửa hồ sơ"),
        backgroundColor: AppColors.trang,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Avatar
                      Obx(() {
                        String? avatarUrl = imageController.avatarUrl.value;
                        print(avatarUrl);
                        XFile? selectedImage =
                            imageController.selectedImage.value;
                        return Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    selectedImage != null
                                        ? FileImage(File(selectedImage.path))
                                        : (avatarUrl != null &&
                                            avatarUrl.isNotEmpty)
                                        ? NetworkImage(avatarUrl)
                                        : NetworkImage(
                                          'https://i.pinimg.com/236x/74/ff/3d/74ff3d21b7b1c3c9b050cbce04e81f35.jpg',
                                        ), // Avatar mặc định
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    XFile? imageFile =
                                        await GetMediaGallery()
                                            .pickImageFromGallery();
                                    if (imageFile != null) {
                                      imageController.setSelectedImage(
                                        imageFile,
                                      ); // Cập nhật ảnh tạm thời
                               
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.blue,
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 30),

                      _buildInput(
                        label: "Tên",
                        icon: Icons.person,
                        controller: nameController,
                      ),
                      const SizedBox(height: 16),

                      _buildInput(
                        label: "Username",
                        icon: Icons.alternate_email,
                        controller: usernameController,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: bioController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Tiểu sử",
                          prefixIcon: Icon(Icons.info_outline),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (text) {
                          final lines = '\n'.allMatches(text).length + 1;
                          if (lines > 3) {
                            final trimmed = text.substring(
                              0,
                              text.lastIndexOf('\n'),
                            );
                            bioController.text = trimmed;
                            bioController
                                .selection = TextSelection.fromPosition(
                              TextPosition(offset: trimmed.length),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildInput(
                        label: "Số điện thoại",
                        icon: Icons.phone,
                        controller: phoneController,
                      ),
                      const SizedBox(height: 16),

                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildInput(
                            label: "Ngày sinh",
                            icon: Icons.cake,
                            controller: birthdayController,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value:
                            selectedGender.isEmpty ? 'Other' : selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Giới tính',
                          prefixIcon: Icon(Icons.wc),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items:
                            ['Male', 'Female', 'Other'].map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            selectedGender = value;
                          }
                        },
                      ),

                      const Spacer(),

                      ElevatedButton(
                        onPressed: saveChanges,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.dohong,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Lưu thay đổi",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.trang,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = selectedBirthday ?? DateTime.now();
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != selectedBirthday) {
      selectedBirthday = picked;
      birthdayController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  void saveChanges() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final bio = bioController.text.trim();
    final phone = phoneController.text.trim();
    final birthday = birthdayController.text.trim();
    final gender = selectedGender;

    final nameParts = name.split(RegExp(r'\s+'));
    final firstName = nameParts.sublist(0, nameParts.length - 1).join(' ');
    final lastName = nameParts.isNotEmpty ? nameParts.last : '';

    try {
      String formattedDate = birthday;
      if (birthday.contains('/')) {
        List<String> dateParts = birthday.split('/');
        formattedDate = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
      }

      await UpdateUserController.updateUserapi(
        firstname: firstName,
        lastname: lastName,
        username: username,
        bio: bio,
        phone: phone,
        birthdate: formattedDate,
        gender: gender,
        avatarPath: imageController.selectedImage.value?.path,
      );

      // Cập nhật lại UserController
      final updatedUser = Userapp(
        id: userController.user.value?.id,
        firstname: firstName,
        lastname: lastName,
        username: username,
        bio: bio,
        phone: phone,
        birthdate: formattedDate,
        gender: gender,
        avatar: userController.user.value?.avatar,
      );

      userController.updateUser(updatedUser);

    } catch (e) {
      print('Lỗi khi lưu thay đổi: $e');
    }
  }

  Widget _buildInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    GestureTapCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
