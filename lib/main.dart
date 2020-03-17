
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gavel/modules/flip.dart';
import 'package:gavel/modules/timerModule.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastmasters gavel app',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage();

  @override
  State<StatefulWidget> createState() => HomePageState();


}
class HomePageState extends State<HomePage>{
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
    return Stack(
        children: [Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color.fromRGBO(10, 151, 187, 1),Color.fromRGBO(17, 12, 97, 1)],))
        ),
          Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(child:Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FinalFlipper(stream: controller.stream),
                    Padding(
                        padding: EdgeInsets.only(top: 30 ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25 - 29,
                          child: Padding(
                            child: TimerModule(callBack),
                            padding: EdgeInsets.all(20),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                          ),
                        ))]
              )
              )
          )
        ]);
  }


}
