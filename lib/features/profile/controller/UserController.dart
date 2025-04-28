import 'package:get/get.dart';
import 'package:tiktok_app/models/User.dart';

class UserController extends GetxController {
  var user = Rxn<Userapp>(); // Biến user có thể null

  void setUser(Userapp newUser) {
    print("vo day");
    user.value = newUser;
  }

  void updateUser(Userapp updatedUser) {
    user.value = updatedUser;
  }

  void clearUser() {
    user.value = null;
  }
}
