import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key, this.user}) : super(key: key);
  static const routeName = '/profile';
  final FirebaseUser user;

  Widget _buildCard(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(user.photoUrl),
        title: Text(user.displayName),
        subtitle: Text(user.email),
        trailing: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/profile-edit', arguments: user);
          },
        ),        
      ),
    );
  }

  Widget _buildSignOut(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('Sign out'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
            // Navigator.pushReplacementNamed(context, '/auth');
          },
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildCard(context),
            _buildSignOut(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: _buildBody(context),
    );
  }
}