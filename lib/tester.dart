import 'package:flutter/material.dart';
import 'package:gavel/member_progress/member_progress_fragment.dart';
import 'package:gavel/timer/timer/main_timer_page.dart';
import 'package:gavel/timer/timer/report_folder.dart';

void main() => runApp(TimerList());

class Tester extends StatefulWidget{
  final widget;
  Tester(this.widget);
  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  final _title = "Tester";
  Widget _test;
  @override
  initState(){
    _test = widget.widget;
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    assert(_test != null);
    return Scaffold(
        body: _test,
      
    );

  }
}
