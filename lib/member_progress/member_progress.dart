

import 'package:flutter/material.dart';
import 'package:gavel/member_progress/member_progress_fragment.dart';


/// This Widget is the main application widget.
class MemberProgressPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MyStatefulWidget();
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
  MemberProgressFragment('Pathways', 'Pathways'),
    MemberProgressFragment('CC', 'CC'),
  MemberProgressFragment('ACB', 'ACB'),
  MemberProgressFragment('ACS', 'ACS'),
  MemberProgressFragment('ACG', 'ACG'),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        showSelectedLabels: true,
        unselectedItemColor: Colors.blueGrey.withOpacity(0.3),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Pathways'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star
            ),
            title: Text('CC'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('ACB'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('ACG'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}