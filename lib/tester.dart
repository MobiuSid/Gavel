import 'package:flutter/material.dart';
import 'package:gavel/modules/fragment_handler.dart';
void main() => runApp(Tester());

class Tester extends StatefulWidget{

  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  final _title = "Tester";

  Widget _test = EventsFragment();
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    assert(_test != null);
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: _test,
      )
    );

  }
}