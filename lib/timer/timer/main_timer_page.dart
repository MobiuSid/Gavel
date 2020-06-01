import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gavel/main.dart';
import 'package:gavel/timer/timer/report_folder.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
class TimerList extends StatefulWidget{

final _db = Firestore.instance;




  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TimerListState();
  }
  }

  class TimerListState extends State<TimerList>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/background_img.jpg'),
            fit: BoxFit.cover),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 2, horizontal: 4
        ),
        child: Column(
        
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.transparent,
              height: 40,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 16, 2),
                  child: RaisedButton(onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Report())
                    ),
                    child: Text(
                      'Report', style: GoogleFonts.ubuntu(
                        color: Colors.black
                      ),
                    )
                    ,color: Colors.red,),
                    )
                )
              ),
            Container(
            height: MediaQuery.of(context).size.height - 100,
            color: Colors.transparent,
            child: CollapsingList()
            )
            ],
      )  
    )
    )
    );
  }





  }
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, 
      double shrinkOffset, 
      bool overlapsContent) 
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
 Widget _timeWithText(String text, int seconds, Color color){
   return Row(
     mainAxisSize: MainAxisSize.min,
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       Text(
         text + ' ' ,
         style: GoogleFonts.ubuntu(
         )
       ),
       Text(
         (seconds~/60).toInt().toString()+ ':' + (seconds % 60).toString().padLeft(2,'0'),
         style: GoogleFonts.ubuntu(
           color: color
         )
       ),
     ],
   );
 }
 Widget buildList(BuildContext context,List<DocumentSnapshot> snapshots){
   
    return SliverList(
      delegate: SliverChildListDelegate(
        
      snapshots.map((e) {
          return GestureDetector(
            onTap: () => {
              Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              Speaker.fromSnapshot(e), e.documentID
          ),))
        
            },
            child: Dismissible(
        direction: DismissDirection.startToEnd,              
              onDismissed: (direction){
                setState(){
                  snapshots.remove(e);
                }
                Firestore.instance.collection('timer').document(e.documentID).delete();                
              },
              key: Key(e.data.toString()),
              child: Padding(
            padding: EdgeInsets.all(4),
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
      colors: [Colors.white.withOpacity(0.8), Colors.cyan.shade100.withOpacity(0.8)]),
      boxShadow: [BoxShadow(
        color: Colors.black38,
        blurRadius: 2,
        spreadRadius: 2
      )]),
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  e.data['name'].toString(), style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _timeWithText('Green card- ', e.data['green_time'], Colors.green),
                  _timeWithText('Yellow card- ', e.data['yellow_time'], Colors.yellow), ],
                
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                   _timeWithText('Red card- ', e.data['red_time'], Colors.redAccent),
                  _timeWithText('Over time- ', e.data['over_time'], Colors.redAccent),
                ]),
              
              ],
            ),
          )
          )
          )
          );
        }).toList()
      ),
    );
  
  }

  Widget sliverListStreamBuilder(int index, BuildContext context){
    var db = Firestore.instance;
    var collectionName = 'timer';
    var role;
    switch(index){
      case 0: role = 'Speaker';
      break;
      case 1: role = 'Evaluator';
      break;
      case 2: role  = 'Table topics';
      break;
    }
    return StreamBuilder(
    stream: db.collection(collectionName).where('role', isEqualTo: role,).where('recorded', isEqualTo: false).getDocuments().asStream(),
    builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
    
      return buildList(context, snapshot.data.documents.toList());        
      }else{
        return SliverList(
          delegate: SliverChildListDelegate(
            [LinearProgressIndicator()]
          ),
        );
      }

    },
    );
  
  }

class CollapsingList extends StatefulWidget {
  @override
  _CollapsingListState createState() => _CollapsingListState();
}

class _CollapsingListState extends State<CollapsingList> {
  SliverPersistentHeader makeHeader(String headerText, BuildContext context, int index) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 45,
        maxHeight: 50,
        child: Container(
          width: MediaQuery.of(context).size.width - 8,
          color: Colors.white,
         child:Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(headerText
                    ,textAlign: TextAlign.left,
                    style: GoogleFonts.ubuntu(
                      fontSize: 16
                    ),
                    ),
                  ), RaisedButton(
                    onPressed: () => showDialog(context: context,builder: (context) => AddButtonDialog(index)), color: Colors.blueAccent, splashColor: Colors.blue.shade900,
                  child: 
          Text(
            'Add', 
            style: GoogleFonts.ubuntu(),
          ))
           ],
         )
              ),
      )
      ,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return CustomScrollView(
      slivers: <Widget>[
        makeHeader('Speakers:', context, 0),
        sliverListStreamBuilder(0, context),
        makeHeader('Evaluators:', context, 1),
        sliverListStreamBuilder(1, context),
        makeHeader('Table-Topics:', context, 2),
        sliverListStreamBuilder(2, context),
        
      ],
    );
  }
}

class AddButtonDialog extends StatefulWidget{

  final index;
  
  AddButtonDialog(this.index);
  
  @override
  _AddButtonDialogState createState() => _AddButtonDialogState();
}

class _AddButtonDialogState extends State<AddButtonDialog> {
  

  final _nameController = TextEditingController();

  final _header = 'Speaker Details';

  final _name = 'Name:';

  final defaultTimeList = [[5,6,7,8,0,0,0,0],[1,2,2,3,30,0,30,0],[1,1,2,2,0,30,0,30]];

  final formKey = GlobalKey<FormState>();

  final textKey = GlobalKey<FormFieldState>();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.greenMinuteState = defaultTimeList[widget.index][0];
    this.yellowMinuteState = defaultTimeList[widget.index][1];
    this.redMinuteState = defaultTimeList[widget.index][2];
    this.overTimeMinuteState = defaultTimeList[widget.index][3];

    this.greenSecondsState = defaultTimeList[widget.index][4];
    this.yellowSecondsState = defaultTimeList[widget.index][5];
    this.redSecondsState = defaultTimeList[widget.index][6];
    this.overTimeSecondsState = defaultTimeList[widget.index][7];

 
  }
  var greenMinuteState;
  var greenSecondsState;
  var yellowMinuteState;
  var redMinuteState;
  var overTimeMinuteState;
  var yellowSecondsState;
  var redSecondsState;
  var overTimeSecondsState;

  String _role(){
    switch(widget.index){
      case 0: return 'Speaker';
      break;
      case 1: return 'Evaluator';
      break;
      case 2: return 'Table topics';
      break;
    }
  }

  bool _logicFunction(){
if(_timeChecker(greenMinuteState, greenSecondsState, yellowMinuteState, yellowSecondsState) && 
_timeChecker(yellowMinuteState, yellowSecondsState, redMinuteState, redSecondsState) &&
_timeChecker(redMinuteState, redSecondsState, overTimeMinuteState, overTimeSecondsState) ){
  return true;
}else{
  return false;
}
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      children:[
      Form(
      key: formKey,
      child: Column(
      children: [
        Text(
          _header, 
          style: GoogleFonts.ubuntu(
            fontSize: 16, fontWeight: FontWeight.bold
          ),textAlign: TextAlign.center, 
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0
          ),
          child: Text(
            _name, style: GoogleFonts.ubuntu(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: TextFormField(
            key: textKey,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            controller: _nameController,
          ),
        ),
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Green card:', style: GoogleFonts.ubuntu(),
        ),
        SizedBox(
          width: 8,
        ),DropdownButton<int>(
            value: greenMinuteState,
        icon: Icon(Icons.arrow_drop_down),
        items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString(), style: GoogleFonts.ubuntu(),),
          );
        }).toList(),
        onChanged: (int value){
          setState(() {
            greenMinuteState = value;
          });
          return null;
        },),DropdownButton<int>(value: greenSecondsState,
        icon: Icon(Icons.arrow_drop_down),
        items: [0, 30].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString().padLeft(2, '0'), style: GoogleFonts.ubuntu(),),
          );
        }).toList(),
        onChanged: (int value){
          setState(() {
            greenSecondsState = value;
          });
          return null;
        })
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Yellow card:', style: GoogleFonts.ubuntu(),
        ),
        SizedBox(
          width: 8,
        ),DropdownButton<int>(
            value: yellowMinuteState,
        icon: Icon(Icons.arrow_drop_down),
        items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString(), style: GoogleFonts.ubuntu(),),
          );
        }).toList(),
        onChanged: (int value){
          setState(() {
            yellowMinuteState = value;
          });
          return null;
        },),DropdownButton<int>(value: yellowSecondsState,
        icon: Icon(Icons.arrow_drop_down),
        items: [0, 30].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString().padLeft(2, '0'), style: GoogleFonts.ubuntu(),),
          );
        }).toList(),
        onChanged: (int value){
          setState(() {
            yellowSecondsState = value;
          });
          return null;
        })
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Red Card', style: GoogleFonts.ubuntu(),
        ),
        SizedBox(
          width: 8,
        ),DropdownButton<int>(
            value: redMinuteState,
        icon: Icon(Icons.arrow_drop_down),
        items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString(), style: GoogleFonts.ubuntu(),),
          );
        }).toList(),
        onChanged: (int value){
          setState(() {
            redMinuteState = value;
          });
          return null;
        },),DropdownButton<int>(value: redSecondsState,
        icon: Icon(Icons.arrow_drop_down),
        items: [0, 30].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString().padLeft(2, '0'), style: GoogleFonts.ubuntu(),),
          );
        }).toList(),
        onChanged: (int value){
          setState(() {
            redSecondsState = value;
          });
          return null;
        })
      ],
    ),Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Over time:', style: GoogleFonts.ubuntu(),
        ),
        SizedBox(
          width: 8,
        ),DropdownButton<int>(
            value: overTimeMinuteState,
        icon: Icon(Icons.arrow_drop_down),
        items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString(), style: GoogleFonts.ubuntu(),),
          );
        }).toList(),
        onChanged: (int value){
          setState(() {
            overTimeMinuteState = value;
          });
          return null;
        },),DropdownButton<int>(value: overTimeSecondsState,
        icon: Icon(Icons.arrow_drop_down),
        items: [0, 30].map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString().padLeft(2, '0'), style: GoogleFonts.ubuntu(),),
          );
        }).toList(),
        onChanged: (int value){
          setState(() {
            overTimeSecondsState = value;
          });
          return null;
        })
      ],
    ),
        

        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 16, 4),
            child: FlatButton(onPressed: (){
            if (formKey.currentState.validate()){
            print(textKey.currentState.value);
            if(_logicFunction()){
              Fluttertoast.showToast(
        msg: "Uploading",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
    );
    Firestore.instance.collection('timer').add({
      'name': textKey.currentState.value, 
      'green_time': greenMinuteState * 60 + greenSecondsState,
      'yellow_time': yellowMinuteState * 60 + yellowSecondsState,
      'red_time': redMinuteState * 60 + redSecondsState,
      'over_time': overTimeMinuteState * 60 + overTimeSecondsState,
      'role': _role(),
      'recorded_time': null,
      'qualified': false, 
      'recorded': false
});
Navigator.of(context).pop();

            }else{
               Fluttertoast.showToast(
        msg: "Verify the values",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

            }
            }
            }, child: Text('Add', style: GoogleFonts.ubuntu(),), color: Colors.blue, splashColor: Colors.blue.shade900,),
          )
        )
      ],
    )
    )
    ]
    );
  

  }


   

bool _timeChecker(int m1, int s1, int m2, int s2){
  if(60* m1 + s1 < 60 * m2 + s2){
    return true;
  }else{
    return false;
  }
}
}

class Speaker {
  final String name;
  final int greenTime;
  final int redTime;
  final int yellowTime;
  int recordedTime;
  final int overTime;
  final String role;
  final DocumentReference reference;
  bool status;
  bool qualified;
  
  

  Speaker.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['green_time'] != null),
        assert(map['yellow_time'] != null),
        assert(map['red_time'] != null),
        assert(map['over_time'] != null),
        assert(map['role'] != null),
        name = map['name'],
        role = map['role'],
        greenTime = map['green_time'],
        yellowTime = map['yellow_time'],
        redTime = map['red_time'],
        overTime = map['over_time'],
        recordedTime = map['recorded_time']{
        if(recordedTime == null){
        status = false;
        }else{
        status = true;
        }
        }

  

  Speaker.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

  
}



