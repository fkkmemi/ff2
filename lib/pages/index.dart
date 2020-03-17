import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomePage'),),
      body: RaisedButton(
        child: Text('logout'),
        onPressed: () async {       
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, '/auth');
        },
      )
    );
  }
}