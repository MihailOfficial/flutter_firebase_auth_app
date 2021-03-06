import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info/package_info.dart';
import 'Dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import 'Home.dart';


bool isShirt = true;
List<bool> isSelected = [false, false];

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Add Clothing"),

        actions: <Widget>[LogoutButton()],
        backgroundColor: Color.fromRGBO(141, 162, 144, 1),
      ),
      drawer: Drawer(
        child: FutureBuilder<FirebaseUser>(
            future: AuthService().getUser,
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Provider.of<MenuStateInfo>(context)
                    .setCurrentUser(snapshot.data);
                return MenuDrawer();
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      // body: StreamProvider<List<Item>>.value(
      //   // when this stream changes, the children will get
      //   // updated appropriately
      //   stream: DataService().getItemsSnapshot(),
      //   child: ItemsList(),
      // ),
      //body: ,

      body:  MyApp1(),

    );

  }
}
class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Onboarding Concept',

      home: Builder(
        builder: (BuildContext context) {
          var screenHeight = MediaQuery.of(context).size.height;
          return ImageCapture();
        },
      ),
    );
  }
}
class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,

        // ratioX: 1.0,
        // ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Clothing',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,

        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 3.0,
          aspectRatioLockEnabled: true,

          aspectRatioLockDimensionSwapEnabled: true,
        ));

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              color: Colors.black,
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Container(
                padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.grey,
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  color: Colors.grey,
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Uploader(
                file: _imageFile,
              ),
            )
          ]
          else if (_imageFile == null) ...[
            Container(
              child: Container(
                  padding: EdgeInsets.all(40),
                  child: Center(
                      child: Text(
                          'As you purchase new clothes, we recommend placing the clothing article on your bed and taking a nice photo. Please note that this photo will be used on the community tab and as such, will be public.')
                  )
              )
            )
          ]
        ],
      ),
    );
  }
}


/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: 'gs://vfhack-d6add.appspot.com');

  StorageUploadTask _uploadTask;

  _startUpload() async {
    String usrid = (await FirebaseAuth.instance.currentUser()).uid;
    String filePath;
    if(isShirt){
      filePath = usrid + '/shirts/${DateTime.now()}.png';
    } else {
      filePath = usrid + '/pants/${DateTime.now()}.png';
    }


    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow, size: 50),
                      onPressed: _uploadTask.resume,
                    ),
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause, size: 50),
                      onPressed: _uploadTask.pause,
                    ),


                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(fontSize: 20),
                  ),
                ]);
          });
    } else {
      return Column (
        children: [

          ToggleButtons(
                children: <Widget>[

              Text('   Shirt   '),
                  Text('   Pant   '),
              ],
            onPressed: (int index) {
              setState(() {
                for (int indexBtn = 0;indexBtn < isSelected.length;indexBtn++) {
                  if (indexBtn == index) {
                    isSelected[indexBtn] = true;
                  } else {
                    isSelected[indexBtn] = false;
                  }
                }
              });
            },
              isSelected: isSelected,
          ),
      FlatButton.icon(
          color: Colors.lightBlueAccent,
          label: Text('Upload to cloud'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload)]);
    }
  }
}