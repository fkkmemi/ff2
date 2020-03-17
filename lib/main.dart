import 'package:ff2/pages/splash.dart';
import 'package:flutter/material.dart';
import 'pages/auth.dart';
import 'pages/index.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';

void main() => runApp(FFApp());

class FFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      // home: Main(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/auth': (context) => AuthPage(),
        '/home': (context) => HomePage(),
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}
