import 'package:flutter/material.dart';
import 'package:gavel/modules/frontPageNav.dart';

void main() => runApp(TestApp());

class TestApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  var index;
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
    backgroundColor: Colors.white,
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
    },
  ),
        
      body: Tester()
      ),
    )
    );
  }
}

class Tester extends StatefulWidget{
  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<Tester> {
  final Widget obj = Container(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return finalWidget(context);  
    }

    Widget finalWidget(context){
      if (obj == null){
        return Center(
          child: Text('The widget is empty')
        );
      } else{
        return obj;
      }
    }
}