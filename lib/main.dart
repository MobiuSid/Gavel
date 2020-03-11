import 'package:flutter/material.dart';

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
      home: TimerPage(color: Colors.green),
    );
  }
}

class TimerPage extends StatefulWidget {
  TimerPage({Key key, this.color}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final Color color;

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Color color = Colors.green;
  void _colorChanger() {
    setState(() {
      switch(color){
        case Colors.green:{
          color = Colors.yellow;
        }
        break;
        case Colors.yellow:{
          color = Colors.red;
        }
        break;
        case Colors.red:{
        color = Colors.green;
      } break;

      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        child: Scaffold(
      backgroundColor: color,
    ),
            onTap: _colorChanger
    );
}
}
