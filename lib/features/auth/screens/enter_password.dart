import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_app/blocs/auth/auth_bloc.dart';
import 'package:tiktok_app/blocs/auth/auth_event.dart';
import 'package:tiktok_app/blocs/auth/auth_state.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/core/widgets/button_login.dart';
import 'package:tiktok_app/blocs/user/password_cubit.dart';
import 'package:tiktok_app/features/profile/controller/get_current_user_by_token.dart';

class Enterpassword extends StatelessWidget {
  final String email;
  const Enterpassword({super.key, required this.email});

  Widget _buildValidationItem(bool isValid, String text) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (_) => PasswordCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: AppBar(
              backgroundColor: AppColors.trang,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("Trợ giúp"),
                            content: const Text("Đây là trang nhập mật khẩu."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Đóng"),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // body: BlocListener<AuthBloc, AuthState>(
        //   listener: (context, state) async {
        //     if (state is AuthAuthenticated) {
        //       final user = await GetUserByToken.getUserByToken();
        //       if (context.mounted) {
        //         Navigator.pushReplacementNamed(
        //           context,
        //           '/Home',
        //           arguments: user,
        //         );
        //       }
        //     } else if (state is AuthError) {
        //       ScaffoldMessenger.of(
        //         context,
        //       ).showSnackBar(SnackBar(content: Text(state.message)));
        //     }
        //   },

      body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<PasswordCubit, PasswordState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Nhập mật khẩu",
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: "Nhập mật khẩu",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                context.read<PasswordCubit>().validate(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildValidationItem(
                      state.isLengthValid,
                      "Mật khẩu phải dài từ 8 ký tự trở lên.",
                    ),
                    _buildValidationItem(
                      state.isComplexValid,
                      "Nên có chữ hoa, chữ thường và số.",
                    ),
                    _buildValidationItem(
                      state.hasSpecialChar,
                      "Phải có 1 kí tự đặc biệt",
                    ),
                    const Spacer(),
                    ButtonLogin(
                      onPressed: () {
                        if (state.isAllValid) {
                          _LoginWithEmail(
                            context,
                            email,
                            passwordController.text,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mật khẩu chưa thỏa yêu cầu!'),
                            ),
                          );
                        }
                      },
                      icon: null,
                      backgroundColor: AppColors.dohong,
                      textColor: AppColors.trang,
                      text: const Text('Tiếp tục'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      // ),
    );
  }

  void _LoginWithEmail(BuildContext context, String email, String password) {
    BlocProvider.of<AuthBloc>(context).add(
      EmailLoginRequested(context: context, email: email, password: password),
    );
  }
}
