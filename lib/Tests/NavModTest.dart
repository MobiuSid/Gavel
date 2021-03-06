import 'package:flutter/material.dart';
import 'package:gavel/modules/frontPageNav.dart';

void main() => runApp(TestApp());

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  var _index;
  Tween<Offset> _offsetAnimation;
  @override
  void initState(){
    super.initState();
    _offsetAnimation = Tween<Offset>(
    begin: Offset(1,0),
    end: const Offset(0,0),
    );
    _index = 0;
  }
   final textSet = [
     Center(
         key: ValueKey<int>(0),
       child: Expanded(
         child: Container(
         constraints: BoxConstraints.expand(),
         color: Colors.red,
         child: Text("Screen 1"),
       ),
       )
       ),Center(
         key: ValueKey<int>(1),
       child: Expanded(
         child: Container(
         constraints: BoxConstraints.expand(),
         color: Colors.green,
         child: Text("Screen 2"),
         key: ValueKey<int>(1)         
       ),
       )
       ),Center(
         key: ValueKey<int>(2),
       child: Expanded(
         child: Container(
         constraints: BoxConstraints.expand(),
         color: Colors.blue,
         child: Text("Screen 3"),
         key: ValueKey<int>(2)         
       ),
       )
       ),
   ];


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
      setState(() {
              this._index = index;
      });
    },
  ),
        body:  AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(child: child,
              position: _offsetAnimation.animate(animation),);
            },
            child: textSet[_index],
      ),
    )
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

