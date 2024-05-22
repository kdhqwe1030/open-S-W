import 'package:flutter/material.dart';
import 'package:with_pet/screen/Join_screen.dart';
import 'package:with_pet/screen/home_screen.dart';
import 'package:with_pet/screen/sign_in_screen.dart';
import 'package:with_pet/screen/start_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // '/': (BuildContext context) => SignInScreen(),
        '/': (BuildContext context) => StartScreen(),
        '/home': (BuildContext context) => HomeScreen(),
        '/signin': (BuildContext context) => SignInScreen(),
        '/signin/join': (BuildContext context) => JoinScreen(),
      },
    ),
  );
}
