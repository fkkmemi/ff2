import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _loading = false;

  _googleSignIn () async {
    // final GoogleSignInAccount currentUser = GoogleSignIn().currentUser;
    final bool isSignedIn = await GoogleSignIn().isSignedIn();
    // print('googleuser $isSignedIn');
    GoogleSignInAccount googleUser;
    if (isSignedIn) googleUser = await GoogleSignIn().signInSilently();
    else googleUser = await GoogleSignIn().signIn();
    // final GoogleSignInAccount googleUser = await GoogleSignIn().signIn(); // .signInSilently();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    // print("signed in " + user.displayName);
    return user;
  }

  _buildLoading() {
    return Center(child: CircularProgressIndicator(),);
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text('google login'),
          onPressed: () async {
            setState(() => _loading = true);
            await _googleSignIn();       
            setState(() => _loading = false);
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        RaisedButton(
          child: Text('register'),
          onPressed: () {       
            Navigator.pushNamed(context, '/signup');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignInPage'), ),
      body: _loading ? _buildLoading() : _buildBody()
    );
  }
}