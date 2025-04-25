import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tiktok_app/routes/app_routes.dart';
import 'package:tiktok_app/services/firebase_options.dart';
import 'package:tiktok_app/blocs/auth/auth_bloc.dart';
import 'package:tiktok_app/blocs/user/user_bloc.dart';
import 'package:tiktok_app/features/profile/controller/get_current_user_by_token.dart';
import 'package:tiktok_app/models/User.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "My tiktok App",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Lấy user trước khi chạy app
  final user = await GetUserByToken.getUserByToken();

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final Userapp? user;

  const MyApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(user!),
        ),
      ],
      child: MaterialApp(
        title: 'TikTok Clone',
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: '/startup',
      ),
    );
  }
}
