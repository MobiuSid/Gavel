
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gavel/modules/flip.dart';
import 'package:gavel/modules/timerModule.dart';
import 'package:gavel/timer/timer/main_timer_page.dart';
import 'package:gavel/modules/timerModule.dart';
import 'package:google_fonts/google_fonts.dart';
class TimerCardPage extends StatefulWidget {
  final Speaker speaker;
  final String documentID;
  TimerCardPage(this.speaker, this.documentID
  );

  @override
  State<StatefulWidget> createState() => TimerCardPageState();


}
class TimerCardPageState extends State<TimerCardPage>{
  StreamController controller;
  int callNumber;
  void callBack(){
    if(callNumber == 0) {
      setState(() {
        controller.add(0);
        callNumber++;
      });
    }else if(callNumber == 1){setState(() {
      controller.add(1);
      callNumber++;
    });
    }else{
      setState(() {
        controller.add(2);
        callNumber++;
      });
    }
  }
  void resetCallBack(){
    callNumber = 0;
    controller.add(0);
  }
  @override
  void initState() {
    callNumber = 0;
    controller = new StreamController<int>();
    // TODO: implement initState
    super.initState();
    setState(() {
      controller.add(0);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/background_img.jpg'),
            fit: BoxFit.cover),
      ),
        ),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(child:Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child:  Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: RaisedButton(onPressed: () => Navigator.of(context).pop(),
                      color: Colors.red,
                      splashColor: Colors.redAccent,
                      child:
                         Text(
                        'Back', style: GoogleFonts.ubuntu(color: Colors.black),
                      ),)),
                    ),
                    FinalFlipper(stream: controller.stream),
                    SizedBox(height: 20,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          boxShadow: [

          BoxShadow(
            color: Colors.black38,
            blurRadius: 4,
            spreadRadius: 4
          )
        ],
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.3 - 29,
                          child: Padding(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                TimerModule(callBack, widget.speaker, resetCallBack, widget.documentID),
                                
                              ]),
                            padding: EdgeInsets.all(20),
                          ),
                          
                        )]
              )
              )
          )
        ]));
  }


}

