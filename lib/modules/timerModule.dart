import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gavel/timer/timer/main_timer_page.dart';

bool stopWatchStopped, stopWatchRunning;
class TimerModule extends StatefulWidget{
  final Function fCallBack;
  final Speaker speaker;
    final Function resetCallBack;
  final String documentID;
  final GlobalKey<_PausePlayButtonState> pausePlayButtonState = GlobalKey<_PausePlayButtonState>();

  TimerModule(
    Function() callBack, this.speaker, Function() resetCallBack, this.documentID
): this.fCallBack = callBack,
   this.resetCallBack = resetCallBack;


  @override
  State<StatefulWidget> createState() => TimerModuleState();
}

class TimerModuleState extends State<TimerModule>{
  String text;
  List colorList = [Colors.black, Colors.greenAccent,Colors.yellow,Colors.red ];
  Timer greenTimer, yellowTimer, redTimer, timer, newTimer;
  Stopwatch stopwatch;
  bool stopWatchStarted;
  Duration secondDuration, redDuration, yellowDuration, greenDuration, elapsedDuration;
  Color color;
  PausePlayButton pausePlayButton;
  AlertDialog notify;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    stopWatchRunning = false;
    stopWatchStarted = false;
    stopWatchStopped = false;
    secondDuration = Duration(seconds: 1);
    redDuration = Duration(seconds: widget.speaker.redTime);
    yellowDuration = Duration(seconds: widget.speaker.yellowTime);
    greenDuration = Duration(seconds: widget.speaker.greenTime);
    text = "00:00";
    color = colorList[0];
    pausePlayButton = PausePlayButton(pausePlay, widget.pausePlayButtonState);
  }

  void callback(Timer timer) {
    int seconds, minutes;
    seconds = ((stopwatch.elapsedMilliseconds / 1000 ) % 60).truncate();
    minutes = ((stopwatch.elapsedMilliseconds / 60000 ) % 60).truncate();
    setState(() {
      text = "${minutes.toString().padLeft(2, "0")}:" + "${seconds.toString().padLeft(2, "0")}";
    });
  }
  void _callback() {
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
      }else if(color == Colors.greenAccent){
        color = colorList[2];
        widget.fCallBack();
      }else if(color == Colors.yellow){
        color = colorList[3];
        widget.fCallBack();
      }
    });
    return null;
  }

    void stop(BuildContext context){
    if(stopWatchRunning==false){
      
   Fluttertoast.showToast(
        msg: "Start the timer!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,

        fontSize: 16.0
    );
    }else{
      setState(() {
        stopwatch.stop();
        timer.cancel();
                if(newTimer!=null) newTimer.cancel();
        redTimer.cancel();
        yellowTimer.cancel();
        greenTimer.cancel();
        stopWatchRunning = false;
        stopWatchStopped = true;
        
      });
      showDialog(context: context, builder: (context) => AlertDialog(
  title: Text(
    'Save',
    style: GoogleFonts.ubuntu(), textAlign: TextAlign.center,
  ), 
  titlePadding: EdgeInsets.all(8),
  contentPadding: EdgeInsets.all(8),
  content: Text('Do you want to save your the timing', 
  style: GoogleFonts.ubuntu(
  ),textAlign: TextAlign.center,),
  actions: [
    FlatButton(
      child: Text('No', style: GoogleFonts.ubuntu(
        color: Colors.black
      ),),
      color: Colors.blue,
      onPressed: (){
        Navigator.of(context).pop();
      },
    ),
    FlatButton(
      child: Text('Yes', style: GoogleFonts.ubuntu(
        color: Colors.black
      ),),
      color: Colors.blue,
      onPressed: (){
        Fluttertoast.showToast(
        msg: "Uploading!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
    Firestore.instance.collection('timer').document(widget.documentID).updateData({
      'recorded_time' : (stopwatch.elapsedMilliseconds.toInt() ~/ 1000),
      'qualified' :  qualify(),
      'recorded': true

    });
    
            Navigator.of(context).pop();

      },
    )
  ],
  actionsPadding: EdgeInsets.all(8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0))
),

  ));

    }


  }
bool qualify(){
if(widget.speaker.overTime > stopwatch.elapsedMilliseconds.toInt() ~/ 1000 && widget.speaker.greenTime < stopwatch.elapsedMilliseconds.toInt() ~/ 1000) return true; else return false;
}

  void secondCallback(){
    callback(newTimer);
    timer = Timer.periodic(secondDuration, callback);
  }
  void pausePlay(){
    if(stopWatchRunning==false && !stopWatchStopped){
    if(stopWatchStarted == false){
    setState(() {
        stopwatch.start();
        timer = Timer.periodic(secondDuration, callback);
        redTimer = Timer(redDuration, changeColor);
        yellowTimer = Timer(yellowDuration, changeColor);
        greenTimer = Timer(greenDuration, changeColor);
        stopWatchRunning = true;
        stopWatchStarted = true;
      });
    }
    else{
        setState(() {
        stopwatch.start();
        var elapsed = stopwatch.elapsedMilliseconds.toInt().toString();
        newTimer = Timer(Duration(milliseconds: secondDuration.inMilliseconds - int.parse((elapsed[elapsed.length - 3] + elapsed[elapsed.length - 2] + elapsed[elapsed.length - 1]).toString())), secondCallback);
        print((greenDuration.inMicroseconds - stopwatch.elapsedMicroseconds / 1000).toString());
        if(greenDuration.inMicroseconds - stopwatch.elapsedMicroseconds > 0) greenTimer = Timer(Duration(
          microseconds: greenDuration.inMicroseconds - stopwatch.elapsedMicroseconds), changeColor
        );
        if(yellowDuration.inMicroseconds - stopwatch.elapsedMicroseconds > 0) yellowTimer = Timer(Duration(
          microseconds: yellowDuration.inMicroseconds - stopwatch.elapsedMicroseconds), changeColor
        );
        if(redDuration.inMicroseconds - stopwatch.elapsedMicroseconds > 0) redTimer = Timer(Duration(
          microseconds: redDuration.inMicroseconds - stopwatch.elapsedMicroseconds), changeColor
        );
        stopWatchRunning = true;
      });
    }
    }else{
    
      setState(() {
        stopwatch.stop();
        if(newTimer!=null) newTimer.cancel();
        timer.cancel();
        redTimer.cancel();
        yellowTimer.cancel();
        greenTimer.cancel();
        stopWatchRunning = false;
      
      });

    
    }

  }

  void restart(){
    if(stopWatchRunning==false){
    if(stopWatchStarted == false){
    Fluttertoast.showToast(
        msg: "Start the timer!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
    }
    else{
       setState(() {
        widget.resetCallBack();
        stopWatchRunning = false;
        stopWatchStarted = false;
        stopWatchStopped = false;
        color = colorList[0];
        stopwatch.stop();
        stopwatch.reset();
        redTimer.cancel();
        yellowTimer.cancel();
        greenTimer.cancel();
        timer.cancel();
                if(newTimer!=null) newTimer.cancel();
        _callback();
        widget.resetCallBack();
      });
 setState(() {
        widget.resetCallBack();
          color = colorList[0];
        stopwatch.reset();
        _callback();
        timer.cancel();
        redTimer.cancel();
        yellowTimer.cancel();
        greenTimer.cancel();
        stopWatchRunning = false;
        stopWatchStarted = false;
        stopWatchStopped = false;
      });
    }
    }else{
      setState(() {
        widget.resetCallBack();
        stopWatchRunning = false;
        stopWatchStarted = false;
        stopWatchStopped = false;
        color = colorList[0];
        stopwatch.stop();
        stopwatch.reset();
        redTimer.cancel();
        yellowTimer.cancel();
        greenTimer.cancel();
        timer.cancel();
                if(newTimer!=null) newTimer.cancel();
        _callback();
        widget.resetCallBack();
        stopWatchRunning = false;
      });

    }


  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: MediaQuery.of(context).size.width,
      
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Speaker: ${widget.speaker.name}', 
            style: GoogleFonts.openSans(
              fontSize: 20
            ),),
            Text(
          text,
          style: GoogleFonts.openSans(
            
            fontSize: 25,
            color: color
          ),
        ),
        Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Ink(
                                      decoration: const ShapeDecoration(
            color: Colors.lightBlue,
            shape: CircleBorder(),
          ),
                                      child: IconButton(
                                  icon: Icon(
                                    Icons.stop,
                                  ),
                                  iconSize: 40,
                                  onPressed: (){
                                    stop(context);
                                  },
                                  splashColor: Colors.blue.shade800,
                                  color: Colors.white,
                                  )),
                                  SizedBox(width: 20,),
                                  pausePlayButton,
                                  SizedBox(width: 20,),                                  
                                    Ink(
                                      decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: CircleBorder(),
          ),
                                      child: 
                                      IconButton(
                                  icon: Icon(
                                    Icons.refresh
                                  ),
                                  iconSize: 40,
                                  onPressed: (){
                                    restart();
                                  },
                                  splashColor: Colors.blue.shade800,
                                  color: Colors.white,
                                  ),)]
                                )
                                
                               
        ]
      )
      
    );
  }
}


class _PausePlayButtonState extends State<PausePlayButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
            color: Colors.black,
            shape: CircleBorder(),
          ),
      child: 
      IconButton(
      splashColor: Colors.blue.shade800,
                iconSize: 64,
                icon: AnimatedIcon(
                  color: Colors.white,
                  icon: AnimatedIcons.play_pause,
                  progress: _animationController,
                ),
                onPressed: () => _handleOnPressed(),
              ))
    ;
  }
  void _handleOnPressed() {
          widget.callback();
  if(!stopWatchStopped){
    setState(() {
      stopWatchRunning
          ? _animationController.forward()
          : _animationController.reverse();
    }
  );
  }else{
    Fluttertoast.showToast(
        msg: "The timer has stopped",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,

        fontSize: 16.0
    );
  }
  }
}
class PausePlayButton extends StatefulWidget {
  final callback;
  PausePlayButton(this.callback, Key key): super(key: key);
  @override
  _PausePlayButtonState createState() => _PausePlayButtonState();
}
