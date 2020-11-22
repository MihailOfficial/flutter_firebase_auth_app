import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/ItemsList.dart';
import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:line_icons/line_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'Login.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

    ]);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    print("drawing Home Page");
    return Scaffold(
      //actions: <Widget>[LogoutButton()],
      // body: StreamProvider<List<Item>>.value(
      //   // when this stream changes, the children will get
      //   // updated appropriately
      //   stream: DataService().getItemsSnapshot(),
      //   child: ItemsList(),
      // ),
        backgroundColor: Colors.grey.shade600,
        appBar: AppBar(
          title: Text("My Fashion"),

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
      body: Column(
          children: <Widget>[


      Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child:  Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white,)

              ],
              borderRadius: new BorderRadius.circular(20.0),
            ),
            child:

            new Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child:  Container(


                    height: MediaQuery.of(context).size.height * 0.34,
                    width: MediaQuery.of(context).size.width - 10.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                          fit: BoxFit.cover, image:AssetImage("assets/images/vogue.jpg")),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

                  child:  Container(

                    height: MediaQuery.of(context).size.height * 0.34,
                    width: MediaQuery.of(context).size.width - 10.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                          fit: BoxFit.cover, image: AssetImage("assets/images/vogue.jpg")),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),),
              ],
            ),
          )),
            RaisedButton.icon(
              textColor: Colors.white,
              color: Color.fromRGBO(141, 162, 144, 1),
              onPressed: () {
                // Respond to button press
              },
              icon: Icon(Icons.refresh, size: 20),
              label: Text("REGENERATE"),
            )

          ]));






  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(Icons.exit_to_app),
        onPressed: () async {
          await AuthService().logout();

          // Navigator.pushReplacementNamed(context, "/");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                settings: RouteSettings(name: "LoginPage"),
                builder: (BuildContext context) => LoginPage()),
          );
        });
  }
}
