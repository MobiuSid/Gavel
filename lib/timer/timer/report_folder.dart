import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gavel/finalModules/mainPage.dart';
import 'package:gavel/main_navigation_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class Report extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
          children: [
             Container(
            decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/background_img.jpg'),
            fit: BoxFit.cover),
      ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: RaisedButton(onPressed: () {
                    Firestore.instance.collection('timer').getDocuments().then((snapshot) {
  for (DocumentSnapshot ds in snapshot.documents){
    ds.reference.delete();
  }});
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyApp(0))
                    );},
                    child: Text(
                      'Home', style: GoogleFonts.ubuntu(
                        color: Colors.black
                      ),
                    )
                    ,color: Colors.red,),
                    
                ),
                Container(
                  color: Colors.white.withOpacity(0.7),
                  height: MediaQuery.of(context).size.height - 160,
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text('Speakers:', style: GoogleFonts.ubuntu(
                        fontSize: 20, 
                      ),
                      textAlign: TextAlign.center
                      ,),),
                      sliverListStreamBuilder(0, context),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text('Evaluators:', style: GoogleFonts.ubuntu(
                        fontSize: 20
                      ),textAlign: TextAlign.center,)
                      ,),
                      sliverListStreamBuilder(1, context),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text('Table Topics:', style: GoogleFonts.ubuntu(
                        fontSize: 20
                      ),textAlign: TextAlign.center,),),
                      sliverListStreamBuilder(2, context)


                    ],
                  )
                ),
              ],
            ),
          ),
        ))
          ],
        
    );
  }
  List<Widget> buildList(BuildContext context,List<DocumentSnapshot> snapshots){
   
    return snapshots.map((e) {
          return Container(
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
              _timeWithText('Time - ', e.data['recorded_time'], Colors.black),
              Text(qualified(e.data['qualified'],),
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.bold
              ),), ],
            
            ),
            ],
            ),
          );
        }).toList()
      
    ;
  
  }
  String qualified(bool status){
  if(status) return 'Qualified'; else return 'Disqualified';
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
    stream: db.collection(collectionName).where('role', isEqualTo: role,).where('recorded', isEqualTo: true).getDocuments().asStream(),
    builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
    
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildList(context, snapshot.data.documents.toList())
      );    
      }else{
        return LinearProgressIndicator();
      }

    },
    );
  
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
           fontWeight: FontWeight.bold
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
 
 