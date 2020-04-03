import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  ProfileEditPage({Key key, this.user}) : super(key: key);
  static const routeName = '/profile-edit';
  final FirebaseUser user;

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  File _image;

  Future<File> _compressFile(File file, String tempPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tempPath,
      minWidth: 200,
      minHeight: 200,
      quality: 90,
      // rotate: 90,
    );
    return result;
  }

  Future getImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    if (image == null) return;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = path.join(tempDir.path, path.basename(image.path));
    File tempImage = await _compressFile(image, tempPath);
    print(image.lengthSync());
    print(tempImage.lengthSync());
    setState(() => _image = tempImage);
  }

  Widget _buildCameraButton() {
    return InkWell(
      child: Icon(Icons.photo_camera, color: Colors.white,),
      onTap: () async {
        await getImage(ImageSource.camera);
      },
    );
  }

  Widget _buildPhotoAlbumButton() {
    return InkWell(
      child: Icon(Icons.photo_library, color: Colors.white,),
      onTap: () async {
        await getImage(ImageSource.gallery);
      },
    );
  }

  Widget _buildPhoto() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            child: _image == null ? Image.network(widget.user.photoUrl, fit: BoxFit.cover) : Image.file(_image, fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black54,
            height: 40,
          ),          
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              _buildCameraButton(),
              _buildPhotoAlbumButton(),
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