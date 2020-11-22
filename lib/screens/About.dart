import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:firebase_auth_app/model/PeopleList.dart';
import 'package:firebase_auth_app/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'Dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:firebase_auth_app/components/MatchCard.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'Home.dart';
import 'Settings.dart';
import 'package:tflite/tflite.dart';
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context) ;
    return Scaffold(
      appBar: AppBar(
        title: Text("Community"),
        actions: <Widget>[LogoutButton()],
        backgroundColor: Color.fromRGBO(28, 28, 28, 1),
      ),

      body: TinderTab(),
    );
  }
}
String generateShirt() {
  return "https://picsum.photos/200/300";
}

String generatePant() {
  return "https://picsum.photos/200/300";
}

class TinderTab extends StatefulWidget {
  @override
  _TinderTabState createState() => _TinderTabState();
}

class _TinderTabState extends State<TinderTab>
    with SingleTickerProviderStateMixin {
  void work() async {
    double score = 0;
    var rngShirtUrl;
    var rngPantUrl;
    while(score < 0.8){
      rngPantUrl = generatePant();
      rngShirtUrl = generateShirt();
//    Tflite.runModelOnBinary(
//        binary: await,
//        numResults: 5)
//        .then((value) {  if (value.isNotEmpty) {
//    }});
      var newScore = 1.0; //extract from value
      score = newScore;
    }
    List<Image> result = [];
    result.add(new Image.network(rngShirtUrl));
    result.add(new Image.network(rngPantUrl));
    print(result.length);
    results.add(result);
  }

  List results = [];
  @override
  void initState(){
    for(var i in peoples){
      work();
    }
  }
  bool chng = true;
  bool atCenter = true;
  bool _triggerNotFound = false;
  bool _timeout = false;
  CardController _cardController;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new AnimatedContainer(
          duration: new Duration(milliseconds: 600),
          curve: Curves.fastLinearToSlowEaseIn,
          color: !atCenter
              ? chng ? Colors.redAccent : Colors.greenAccent
              : Colors.blueGrey,
          child: new Center(
            child: _triggerNotFound
                ? !_timeout
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new SizedBox(
                  height: ScreenUtil().setHeight(30.0),
                ),
                new Text(
                  "Searching nearby matchings ...",
                  style: new TextStyle(
                      fontSize: ScreenUtil().setSp(60.0),
                      fontWeight: FontWeight.w200,
                      color: Colors.grey.shade600),
                )
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new SizedBox(
                  height: ScreenUtil().setHeight(550.0),
                ),
                new ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: new Image(
                      width: ScreenUtil().setWidth(400),
                      height: ScreenUtil().setWidth(400),
                      fit: BoxFit.cover,
                      image:
                      new AssetImage('assets/images/abhishekProfile.JPG')),
                ),
                new SizedBox(
                  height: ScreenUtil().setHeight(40.0),
                ),
                new Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(60.0)),
                  child: new Text("There is no one new around you ...",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          wordSpacing: 1.2,
                          fontSize: ScreenUtil().setSp(55.0),
                          fontWeight: FontWeight.w300,
                          color: Colors.grey.shade600)),
                ),

              ],
            )
                : Container(),
          ),
        ),
        new Align(
            alignment: Alignment.topCenter,
            child: new TinderSwapCard(
              animDuration: 800,
              orientation: AmassOrientation.TOP,
              totalNum: peoples.length,
              stackNum: 3,
              swipeEdge: 10.0,
              maxWidth: MediaQuery.of(context).size.width - 10.0,
              maxHeight: MediaQuery.of(context).size.height * 0.81,
              minWidth: MediaQuery.of(context).size.width - 50.0,
              minHeight: MediaQuery.of(context).size.height * 0.80,
              cardBuilder: (context, index) {
                return MatchCard(results[index][0], results[index][1]);
              },
              cardController: _cardController,
              swipeUpdateCallback:
                  (DragUpdateDetails details, Alignment align) {
                /// Get swiping card's alignment
                if (align.x < 0) {
                  //Card is LEFT swiping
                  print("Left align " + align.x.toString());
                  setState(() {
                    if (align.x < -1) atCenter = false;
                    chng = true;
                  });
                } else if (align.x > 0) {
                  //Card is RIGHT swiping
                  print("right align " + align.x.toString());
                  setState(() {
                    if (align.x > 1) atCenter = false;
                    chng = false;
                  });
                }
              },
              swipeCompleteCallback:
                  (CardSwipeOrientation orientation, int index) {
                /// Get orientation & index of swiped card!
                setState(() {
                  atCenter = true;
                  if (index == peoples.length - 1) {
                    _triggerNotFound = true;
                    Future.delayed(Duration(seconds: 5), () {
                      _timeout = true;
                      setState(() {});
                    });
                  }
                });
              },
            )),
       ]);
  }

  double abs(double x) {
    if (x < 0) return x * -1;
    return x;
  }
}
