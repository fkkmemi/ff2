import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key key, this.user}) : super(key: key);
  static const routeName = '/home';
  final FirebaseUser user;

  Widget _buildProfile(context) {
    return Padding(
      padding: EdgeInsets.all(8), 
      child: InkWell(
        child: CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/profile', arguments: user);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: <Widget>[
          _buildProfile(context),          
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