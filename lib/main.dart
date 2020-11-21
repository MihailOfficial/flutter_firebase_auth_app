import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth_app/components/LoadingCircle.dart';
import 'package:firebase_auth_app/components/MenuDrawer.dart';
import 'package:firebase_auth_app/screens/Home.dart';
import 'package:firebase_auth_app/screens/Login.dart';
import 'package:firebase_auth_app/screens/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/auth.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //SharedPreferences storage = await SharedPreferences.getInstance();
  count[0] = 0;
  count[1] = 0;
  count[2] = 0;
  count[3] = 0;

  Util flameUtil = Util();

  final size = await Flame.util.initialDimensions();

  Flame.util.fullScreen();

  tempWidth = size.height;
  tempHeight = size.width;

  game = MyGame(size);
  runApp(MyApp());
  TapGestureRecognizer tapper = TapGestureRecognizer();
  flameUtil.addGestureRecognizer(tapper);

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    print("drawing Main Page");

    FirebaseAnalytics analytics = FirebaseAnalytics();

    analytics.setCurrentScreen(screenName: "Main Screen").then((v) => {});

    return MultiProvider(
      providers: [
        Provider<FirebaseAnalytics>.value(value: analytics),
        Provider<MenuStateInfo>.value(
          value: MenuStateInfo("HomePage"),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        initialRoute: "/",
        home: FutureBuilder<FirebaseUser>(
            future: AuthService().getUser,
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print("drawing main: target screen" +
                    snapshot.connectionState.toString());
                final bool loggedIn = snapshot.hasData; 
                return loggedIn ? HomePage() : LoginPage();
              } else {
                print("drawing main: loading circle" +
                    snapshot.connectionState.toString());
                return LoadingCircle();
              }
            }),
      ),
    );
  }
}
