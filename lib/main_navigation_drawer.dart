import 'package:flutter/material.dart';
import 'package:gavel/finalModules/mainPage.dart';
import 'package:gavel/member_progress/member_progress.dart';
import 'package:gavel/timer/timer/main_timer_page.dart';

void main() => runApp(MyApp(0));

class MyApp extends StatelessWidget {
  final appTitle = 'Toastmasters';
  final int index;
  MyApp(this.index);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(this.index, title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final index;
  MyHomePage(this.index ,{Key key, this.title}) : super(key: key);
  
  final widgetList = [
    HomePage(),
    TimerList(),
    MemberProgressPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.blue.shade800,),
      body: widgetList[this.index],
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Container(
                 decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/toastmasters_app_logo.png'),
            fit: BoxFit.contain),
      ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
              ),
            ),
            ListTile(
              title: Text('Home'),
              
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                 Navigator.push(context,
                    new MaterialPageRoute(builder: (ctxt) => new MyApp(0)));

              },
            ),
            ListTile(
              title: Text('Timer'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                 Navigator.pop(context);                
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new MyApp(1)));

              },
            ),
            ListTile(
              title: Text('Member progress'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                 Navigator.pop(context);

                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new MyApp(2)));

              },
            ),
          ],
        ),
      ),
    );
  }
}