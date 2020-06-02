import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../linear_progress_indicator.dart';

class MemberProgressFragment extends StatelessWidget{
  final pattern;
  final collection;
  MemberProgressFragment(this.pattern, this.collection);

  Widget _buildListItem(BuildContext context, DocumentSnapshot data){
    return Container(
      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.4),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            data.data['name'], style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold
            )),
            Text(
            data.data['pattern'], style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold
            )),
            _buildCircularIndicator(pattern, data),
          
          
        ],
      )
     
    );
  }
  Widget _buildCircularIndicator(String pattern, DocumentSnapshot ds){
    var pathWays = ['L1P1', 'L1P2', 'L1P3', 'L2P1', 'L2P2','L2P3','L3P1','L3P2','L3P3', 'L4P1', 'L4P2','L5P1','L5P2','L5P3'];
    var levels = List.generate(10, (index) => index, growable: false);
    var color = _chooseColor(
      ds.data['pattern']
    );
    return CircularPercentIndicator(
                  radius: 50,
                  lineWidth: 3,
                  percent: _percent(pathWays, levels, pattern, ds.data['level']),
                  center: new Text(ds.data['level'].toString(), style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold)),
                  progressColor: color,
    );
  }
  num _percent(List<String> pathWays, List<int> levels, String pattern, level){
    if(pattern == 'Pathways'){
      return (pathWays.indexOf(level)+1)/pathWays.length;
    }else{
      return level/10;
    }
  }
  Color _chooseColor(String data){
    switch(data){
      case 'Pathways': return Colors.orangeAccent;
      break;
      case 'CC': return Colors.green;
      break;
      case 'ACB': return Colors.yellow;
      break;
      case 'ACS': return Colors.indigo;
      break;
      case 'ACG': return Colors.teal;
      break;
    }
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('member_progress').where('pattern', isEqualTo: pattern).where('collection', isEqualTo: collection).getDocuments().asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
      children: [
        Container(

            decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/background_img.jpg'),
            fit: BoxFit.cover),
      ),
        ),
        
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.cyan.withOpacity(0.1)
                    ),
                    child: Center(
                    
                      child: Text('Member Progress: ' + pattern, style: GoogleFonts.ubuntu(),textAlign: TextAlign.center)),
                  ),
                  SizedBox(height: 10,),
                  Container(
                  height: MediaQuery.of(context).size.height - 220,
                child: _buildBody(context),
                decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(16))
                )
                ,
                )]
                )
                
                )
      ]));
  }

}