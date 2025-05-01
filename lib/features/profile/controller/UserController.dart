import 'package:get/get.dart';
import 'package:tiktok_app/models/User.dart';

class UserController extends GetxController {
  var user = Rxn<Userapp>(); // Biến user có thể null
  RxInt Follower = 0.obs;
  RxInt Following = 0.obs;
  void setUser(Userapp newUser) {
    user.value = newUser;
  }

  void updateUser(Userapp updatedUser) {
    user.value = updatedUser;
  }

  void clearUser() {
    user.value = null;
  }
}
