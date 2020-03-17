import 'dart:async';

import 'package:flutter/material.dart';

class TimerModule extends StatefulWidget{
  final Function fCallBack;

  TimerModule(
    Function() callBack
): this.fCallBack = callBack;

  @override
  State<StatefulWidget> createState() => TimerModuleState();
}

class TimerModuleState extends State<TimerModule>{
  String text;
  List colorList = [Colors.black, Colors.green,Colors.yellow,Colors.red ];
  Timer greenTimer, yellowTimer, redTimer, timer;
  Stopwatch stopwatch;
  bool stopWatchRunning;
  Duration secondDuration, redDuration, yellowDuration, greenDuration;
  Color color;

  @override
  void initState() {
    stopwatch = Stopwatch();
    stopWatchRunning = false;
    secondDuration = Duration(seconds: 1);
    redDuration = Duration(seconds: 15 );
    yellowDuration = Duration(seconds: 10);
    greenDuration = Duration(seconds: 5);
    text = "00:00";
    color = colorList[0];
  }

  void callback(Timer timer) {
    int seconds, minutes;
    seconds = ((stopwatch.elapsedMilliseconds / 1000 ) % 60).truncate();
    minutes = ((stopwatch.elapsedMilliseconds / 60000 ) % 60).truncate();
    setState(() {
      text = "${minutes.toString().padLeft(2, "0")}:" + "${seconds.toString().padLeft(2, "0")}";
    });
  }

  void Function() changeColor() {
    setState(() {
      if(color == Colors.black){
        color = colorList[1];
        widget.fCallBack();
      }else if(color == Colors.green){
        color = colorList[2];
        widget.fCallBack();
      }else if(color == Colors.yellow){
        color = colorList[3];
        widget.fCallBack();
      }
    });
    return null;
  }
  void changeTimerState(){
    if(stopWatchRunning==false){
      setState(() {
        stopwatch.start();
        timer = Timer.periodic(secondDuration, callback);
        redTimer = Timer(redDuration, changeColor);
        yellowTimer = Timer(yellowDuration, changeColor);
        greenTimer = Timer(greenDuration, changeColor);
        stopWatchRunning = true;
      });

    }else{
      setState(() {
        stopwatch.stop();
        timer.cancel();
        redTimer.cancel();
        yellowTimer.cancel();
        greenTimer.cancel();
      });

    }


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.3 * MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: changeTimerState,
        child: Center(
          child: Text(
          text,
          style: TextStyle(
            shadows: [
              Shadow(
                  blurRadius: 6,
                offset: Offset(
                  0.0,4.0
                ),
              color: Colors.blueGrey,

          )
            ],
            fontSize: 50,
            color: color
          ),
        ),
      )
      )
    );
  }
}


