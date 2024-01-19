import 'package:flutter/material.dart';
import 'package:kof_recipe/pages/home_page.dart';
import 'package:kof_recipe/pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
  runApp( MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(198, 155, 89, 1.0),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor:   Colors.white,
          iconTheme: IconThemeData(color: Colors.black)
        )
      ),
      
      debugShowCheckedModeBanner: false,
      home:isLoggedIn? const HomePage() : const WelcomePage(),
    );
  }
}


