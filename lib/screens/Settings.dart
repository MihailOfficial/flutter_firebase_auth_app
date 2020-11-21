import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:flutter/material.dart';

import 'Home.dart';





class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          return HomePage();
        },
      ),
    );
  }
}