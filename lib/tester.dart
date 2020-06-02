import 'package:flutter/material.dart';
import 'package:gavel/member_progress/member_progress_fragment.dart';
import 'package:gavel/timer/timer/main_timer_page.dart';
import 'package:gavel/timer/timer/report_folder.dart';

void main() => runApp(Tester());

class Tester extends StatefulWidget{

  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  final _title = "Tester";

  Widget _test = Report();
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    assert(_test != null);
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: _test,
      )
    );

  }
}
