import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantapp/screens/login-screen.dart';
import 'package:restaurantapp/screens/registration-screen.dart';
//import 'package:restaurantapp/screens/home-screen.dart';
import 'package:restaurantapp/screens/Home_Screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDYhhFF4Y7RR6FRZzx-VuN7urpou2yJoSs",
      appId: "com.example.restaurantapp",
      messagingSenderId: "",
      projectId: "restaurantapp-7ce0d",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'restaurantapp',
      theme: ThemeData(
        
        primarySwatch: Colors.red,
      ),
      home: LoginScreen(),
    );
  }
}