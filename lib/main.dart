import 'package:flutter/material.dart';
import 'package:videochat/Screens/Authentications/SignUp.dart';
import 'package:videochat/constants/Constants.dart';
import 'Screens/Authentications/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pre_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Capture App',
      theme: ThemeData(
        primaryColor: appColor,
        colorScheme: ColorScheme.fromSeed(seedColor: appColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const PreApp(),
    );
  }
}
