import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../methods/toast.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);
  static const routeName = '/auth';

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  StreamSubscription<FirebaseUser> _subscriptionAuth;
  String _message = 'loading...';
  FirebaseUser _firebaseUser;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


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
      if (fu == null) { 
        Navigator.pushReplacementNamed(context, '/signin');
        return;
      }
      setState(() => _firebaseUser = fu);
      if (!fu.isEmailVerified) {
        setState(() => _message = 'Email is not authenticated.');
        return; 
      }
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  Widget _buildReloadButton() {
    return RaisedButton(
      child: Text('Email Confirmed'),
      onPressed: () async {
        final u = await FirebaseAuth.instance.currentUser();
        await u.reload();
        if (!u.isEmailVerified) {          
          toastError(_scaffoldKey, 'Email is not authenticated. please try again');          
          return;
        }
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Account check')
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_message),
              SizedBox(height: 10,),
              _firebaseUser == null ? CircularProgressIndicator() : _buildReloadButton()
            ],
          ),
        ),
      ),
    );
  }
}