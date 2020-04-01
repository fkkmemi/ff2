import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  ProfileEditPage({Key key, this.user}) : super(key: key);
  static const routeName = '/profile-edit';
  final FirebaseUser user;

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {

  Widget _buildPhoto() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            color: Colors.teal,
            constraints: BoxConstraints.expand(),
            child: Image.network(widget.user.photoUrl, fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black54,
            height: 40,
          ),          
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.photo_camera, color: Colors.white, ),
              Icon(Icons.photo_library, color: Colors.white, ),
            ],
          )
        ],        
      ),          
    );    
  }
  Widget _buildName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextFormField(
              decoration: InputDecoration(
                labelText: 'First name*',
                hintText: 'John',
                border: OutlineInputBorder(),
              ),            
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Last name*',
                hintText: 'Doe',
                border: OutlineInputBorder(),
              ),            
            ),          
        ],
      ),
    );    
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        // color: Colors.redAccent,
        height: 200,
        padding: EdgeInsets.all(10),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: _buildPhoto(),
              ),
              Expanded(
                flex: 3,
                child: _buildName(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Edit'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}