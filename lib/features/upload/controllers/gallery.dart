import 'package:image_picker/image_picker.dart';
import 'package:tiktok_app/core/widgets/toast.dart';

class GetMediaGallery {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        return pickedImage;
      } else {
        showErrorToast("Chưa chọn ảnh nào.");
        return null;
      }
    } catch (e) {
      showErrorToast("Lỗi khi chọn ảnh: $e");
      return null;
    }
  }

  Future<XFile?> pickMediaFromGallery() async {
    try {
      final pickedMedia = await _picker.pickMedia();

      if (pickedMedia != null) {
        showSuccessToast("Media được chọn: ${pickedMedia.path}");
        return pickedMedia;
      } else {
        showErrorToast("Chưa chọn media nào.");
        return null;
      }
    } catch (e) {
      showErrorToast("Lỗi khi chọn media: $e");
      return null;
    }
  }
}
