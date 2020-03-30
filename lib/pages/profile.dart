import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);
  static const routeName = '/profile';

  Widget _buildImage() {
    return Text('aaa'

    );
  }

  Widget _buildBody() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildImage(),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ProfilePage'),),
      body: _buildBody(),
    );
  }
}