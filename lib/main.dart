// import 'package:flutter/material.dart';
// import 'routes/app_routes.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TikTok Clone',
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primarySwatch: Colors.red,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       onGenerateRoute: AppRoutes.generateRoute,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tiktok_app/features/auth/screens/Select_birthdate.dart';
import 'package:tiktok_app/features/home/screens/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
