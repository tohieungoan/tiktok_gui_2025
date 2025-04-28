import 'package:get/get.dart';

class PasswordController extends GetxController {
  var isLengthValid = false.obs;
  var isComplexValid = false.obs;
  var hasSpecialChar = false.obs;

  bool get isAllValid => isLengthValid.value && isComplexValid.value && hasSpecialChar.value;

  void validate(String password) {
    isLengthValid.value = password.length >= 8;
    isComplexValid.value = RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password);
    hasSpecialChar.value = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }
}
