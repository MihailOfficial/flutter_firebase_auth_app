import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class MatchCard extends StatefulWidget {

  final Image imageURLOne;
  final Image imageURLTwo;


  MatchCard(@required this.imageURLOne, @required this.imageURLTwo,
     );

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
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


              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width - 10.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                    fit: BoxFit.cover, image: widget.imageURLOne.image),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

            child:  Container(

              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width - 10.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                    fit: BoxFit.cover, image: widget.imageURLTwo.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),),
        ],
      ),
    ));
  }
}
