import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key key, this.user}) : super(key: key);
  static const routeName = '/home';
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('HomePage'),
        title: Text(user.email),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.account_circle),
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/profile');
          //   },
          // ),
          Padding(
            padding: EdgeInsets.all(8),
            child: InkWell(              
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl, scale: 1),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
      body: RaisedButton(
        child: Text('logout'),
        onPressed: () async {       
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, '/auth');
        },
      ),
    );
  }
}