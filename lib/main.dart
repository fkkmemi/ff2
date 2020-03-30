import 'package:flutter/material.dart';
import 'pages/splash.dart';
import 'pages/auth.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/home.dart';
import 'pages/profile.dart';

void main() => runApp(FFApp());

class FFApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Firebase',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: SplashPage.routeName,
      routes: {
        // SplashPage.routeName: (context) => SplashPage(),
        AuthPage.routeName: (context) => AuthPage(),
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        // HomePage.routeName: (context) => HomePage(),
        ProfilePage.routeName: (context) => ProfilePage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomePage.routeName: {
            return MaterialPageRoute(
              builder: (context) {
                return HomePage(user: settings.arguments);
              }
            );
          } break;
        }
        return MaterialPageRoute(
          builder: (context) => SplashPage()
        );
      },

    );
  }
}
