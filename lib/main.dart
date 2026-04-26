import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uat_project/feature/auth/presentation/pages/login_page.dart';
import 'package:uat_project/firebase_options.dart';

import 'feature/auth/presentation/pages/auth_page.dart';
import 'feature/auth/presentation/pages/register_page.dart';

void main() async{
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //run app
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}


