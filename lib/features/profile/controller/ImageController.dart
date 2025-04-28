import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  Rxn<XFile> selectedImage = Rxn<XFile>();  // ảnh mới chọn từ gallery (tạm thời)

  RxnString avatarUrl = RxnString();         // URL từ server

  // Đặt URL mới (khi user đăng nhập xong)
  void setAvatarUrl(String url) {
    avatarUrl.value = url;
  }

  // Đặt ảnh file vừa chọn
  void setSelectedImage(XFile image) {
    selectedImage.value = image;
  }

  // Clear ảnh file tạm
  void clearSelectedImage() {
    selectedImage.value = null;
  }
    String getImagePath() {
    return selectedImage.value?.path ?? avatarUrl.value ?? 'https://i.pinimg.com/236x/74/ff/3d/74ff3d21b7b1c3c9b050cbce04e81f35.jpg';
  }
}
