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
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Home',
      style: optionStyle,
    ),
    Text(
      'Index 2: Likes',
      style: optionStyle,
    ),
    Text(
      'Index 3: Search',
      style: optionStyle,
    ),

  ];
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
      body: Column(
          children: <Widget>[

      OutlineButton(
        textColor: Color(0xFF6200EE),
        highlightedBorderColor: Colors.black.withOpacity(0.12),
        onPressed: () {
          // Respond to button press
        },
        child: Text("OUTLINED BUTTON"),
      ),

      Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
          ))]),



      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.grey[800],
                tabs: [
                  GButton(
                    icon: LineIcons.male,
                    text: 'Dress',
                  ),
                  GButton(
                    icon: LineIcons.thumbs_o_up,
                    text: 'Rate',
                  ),
                  GButton(
                    icon: LineIcons.plus,
                    text: 'New',
                  ),

                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ));



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
