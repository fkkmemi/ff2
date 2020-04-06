import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileEditPage extends StatefulWidget {
  ProfileEditPage({Key key, this.user}) : super(key: key);
  static const routeName = '/profile-edit';
  final FirebaseUser user;

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  File _image;
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _nameChanged = false;
  bool _loading = false;

  @override
  void initState() { 
    super.initState();
    final names = widget.user.displayName.split(' ');
    if (names.length < 2) {
      firstNameInputController = TextEditingController();
      lastNameInputController = TextEditingController();
      return;
    }
    firstNameInputController = TextEditingController(text: names[0]);
    lastNameInputController = TextEditingController(text: names[1]);

    firstNameInputController.addListener(() {
      if (firstNameInputController.text == names[0] && lastNameInputController.text == names[1]) setState(() => _nameChanged = false);
      else setState(() => _nameChanged = true);
    });

    lastNameInputController.addListener(() {
      if (firstNameInputController.text == names[0] && lastNameInputController.text == names[1]) setState(() => _nameChanged = false);
      else setState(() => _nameChanged = true);
    });
  }

  @override
  void dispose() {
    firstNameInputController.dispose();
    lastNameInputController.dispose();
    super.dispose();
  }

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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'First name*',
                hintText: 'John',
                border: OutlineInputBorder(),              
              ),            
              controller: firstNameInputController,
              validator: (value) {
                if (value.length < 1) return 'Please enter a valid first name.';
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Last name*',
                hintText: 'Doe',
                border: OutlineInputBorder(),
              ),            
              controller: lastNameInputController,
              validator: (value) {
                if (value.length < 1) return 'Please enter a valid last name.';
                return null;
              },
            ),          
          ],
        ),
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

  _save () async {
    setState(() => _loading = true);
    if (_image != null) {
      final StorageReference ref = FirebaseStorage().ref().child('images').child('users').child(widget.user.uid);
      final StorageUploadTask uploadTask = ref.putFile(_image,);
      uploadTask.events.listen((event) {
        print(event);
        print('EVENT ${event.type}');
        if (event.type == StorageTaskEventType.success) {
          ref.getDownloadURL()
            .then((url) async {
              _image.deleteSync();
              final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
              userUpdateInfo.photoUrl = url;
              if (_nameChanged) userUpdateInfo.displayName = firstNameInputController.text + ' ' + lastNameInputController.text;
              await widget.user.updateProfile(userUpdateInfo);
              await widget.user.reload();
              setState(() => _loading = false);
              Navigator.pushNamedAndRemoveUntil(context, '/auth', (r) => false);
            });
        }
      });
    } else {
      final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = firstNameInputController.text + ' ' + lastNameInputController.text;
      await widget.user.updateProfile(userUpdateInfo);
      await widget.user.reload();
      setState(() => _loading = false);
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (r) => false);
    }
  }

  Widget _buildSaveButton () {
    if (_loading) {
      return Center(
        child: Container(
          width: 40,
          height: 40,
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(backgroundColor: Colors.white,),
        )
      );
    }
    return IconButton(
      icon: Icon(Icons.save),
      onPressed: _image != null || _nameChanged ? () => _save() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Edit'),
        actions: <Widget>[
          _buildSaveButton(),
        ],
      ),
      body: _buildBody(),
    );
  }
}