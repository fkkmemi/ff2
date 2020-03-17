import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  StreamSubscription<FirebaseUser> _subscriptionAuth;
  String _message = 'loading...';

  @override
  void initState() { 
    super.initState();
    _streamOpen();
  }

  @override
  void dispose() {
    _subscriptionAuth.cancel();
    super.dispose();
  }

  _streamOpen() {
    _subscriptionAuth = FirebaseAuth.instance.onAuthStateChanged.listen((fu) {
      if (fu == null) return Navigator.pushReplacementNamed(context, '/signin');
      return Navigator.pushReplacementNamed(context, '/home');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account check')
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_message),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}