import 'package:flutter/material.dart';
import 'package:gavel/member_progress/member_progress.dart';
import 'package:gavel/modules/event_fragment.dart';
import 'package:gavel/modules/fragment_handler.dart';
import 'package:gavel/modules/frontPageNav.dart';
import 'package:gavel/modules/other_social_media.dart';
import 'package:gavel/timer/timer/main_timer_page.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _index = 0;
  final widgetSet = [
    EventsFragment(),
    Events(),
    Other()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

     
        bottomNavigationBar: CurvedNavigationBar(
    backgroundColor: Colors.cyan.shade500,
    items: <Widget>[
      Text(
      'Meets',
      style: TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black
      ),
      ), Text(
      'Events',
      style: TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black
      ),
      ), Text(
      'Posts',
      style: TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black
      ),
      )
    ],
    onTap: (index) {
      //Handle button tap
      setState(() {
            this._index = index;
      });
    },
  ),
      
      body: widgetSet[this._index]
      )
    ;
  }
  
}


