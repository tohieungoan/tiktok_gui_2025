import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/auth/controllers/PasswordController.dart';
import 'package:tiktok_app/features/auth/controllers/auth_service.dart';
import 'package:tiktok_app/features/profile/controller/UserController.dart';



class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Đăng xuất',
                style: TextStyle(fontSize: screenHeight * 0.022),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await AuthService.logout(context);
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.lock, color: Colors.blue),
              title: Text(
                'Đổi mật khẩu',
                style: TextStyle(fontSize: screenHeight * 0.022),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showChangePasswordSheet(context);
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent),
              title: Text(
                'Xóa tài khoản',
                style: TextStyle(fontSize: screenHeight * 0.022),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Xác nhận'),
                      content: const Text('Bạn chắc chắn muốn xóa tài khoản?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng dialog
                          },
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(); // Đóng dialog
                            await AuthService.deleteUser(
                              idUser: userController.user.value!.id.toString(),
                            );
                          },
                          child: const Text(
                            'Xóa',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Phiên bản 1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenHeight * 0.018,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final passwordController = Get.put(PasswordController());


    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.6, // Tăng chiều cao BottomSheet
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Text(
                    'Đổi mật khẩu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu hiện tại',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    onChanged: (value) {
                      passwordController.validate(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu mới',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          passwordController.isLengthValid.value
                              ? '✔ Đủ 8 ký tự'
                              : '❌ Ít nhất 8 ký tự',
                          style: TextStyle(
                            color:
                                passwordController.isLengthValid.value
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          passwordController.isComplexValid.value
                              ? '✔ Chữ hoa, thường, số'
                              : '❌ Có chữ hoa, thường, số',
                          style: TextStyle(
                            color:
                                passwordController.isComplexValid.value
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          passwordController.hasSpecialChar.value
                              ? '✔ Ký tự đặc biệt'
                              : '❌ Có ký tự đặc biệt',
                          style: TextStyle(
                            color:
                                passwordController.hasSpecialChar.value
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Xác nhận mật khẩu mới',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            Get.snackbar('Hủy', 'Đã hủy đổi mật khẩu');
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Hủy',
                            style: TextStyle(color: AppColors.trang),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              AppColors.dohong,
                            ),
                          ),
                          onPressed: () async {
                            if (confirmPasswordController.text !=
                                newPasswordController.text) {
                              Get.snackbar(
                                'Thất bại',
                                'Mật khẩu xác nhận không trùng khớp',
                              );
                              return;
                            }
                            if (!passwordController.isAllValid) {
                              Get.snackbar(
                                'Thất bại',
                                'Mật khẩu mới không đủ mạnh',
                              );
                              return;
                            }
                            // TODO: Gọi API đổi mật khẩu ở đây
                            await AuthService.changePassword(
                              oldPassword: currentPasswordController.text,
                              newPassword: newPasswordController.text,
                            );
                          },
                          child: const Text(
                            'Xác nhận',
                            style: TextStyle(color: AppColors.trang),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
