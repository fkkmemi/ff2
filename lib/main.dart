import 'package:flutter/material.dart';
import 'pages/splash.dart';
import 'pages/auth.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/home.dart';
import 'pages/profile.dart';
import 'pages/profile_edit.dart';

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
        AuthPage.routeName: (context) => AuthPage(),
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomePage.routeName: {
            return MaterialPageRoute(
              builder: (context) => HomePage(user: settings.arguments)
            );
          } break;
          
          case ProfilePage.routeName: {
            return MaterialPageRoute(
              builder: (context) => ProfilePage(user: settings.arguments)
            );
          } break;
          
          case ProfileEditPage.routeName: {
            return MaterialPageRoute(
              builder: (context) => ProfileEditPage(user: settings.arguments)
            );
          } break;

          default: {
            return MaterialPageRoute(
              builder: (context) => SplashPage()
            );
          } break;
        }        
      },
    );
  }
}
