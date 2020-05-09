import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        body: Tester()
      ),
    );
  }
}

class Tester extends StatelessWidget{
  final Widget obj;

  const Tester({Key key, this.obj}) : super(key: key);

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