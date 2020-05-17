
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class EventsFragment extends StatefulWidget{
    final _db = Firestore.instance;    
    
  @override
  _EventsFragmentState createState() => _EventsFragmentState();
}

class _EventsFragmentState extends State<EventsFragment> {
  var _listView;
  List<String> _fileList = List<String>();



@override
  void initState() {
    super.initState();
    this._listView = StreamBuilder(
      stream: widget._db.collection('meetings').document('5zn8voqJl9wTnc6JwpfQ').snapshots(),
      builder:  (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      var futureImage;
            if(snapshot.hasError){
              futureImage = Text('${snapshot.error}');
            }else{
              switch(snapshot.connectionState){
                case ConnectionState.none: {
                  futureImage = Text('Waiting');
                  break;
                }
                case ConnectionState.waiting: {
                  futureImage = Text('Waiting');
                  break;
                }
                default: {
                  snapshot.data.data..forEach((k,v) => _fileList.add(v));
                  print(_fileList);
                  futureImage = ListView.builder(
                  itemCount: _fileList.length,
                  itemBuilder: (context, index) => EventCard(context, FirebaseStorage().ref().child('${_fileList[index]}'))
                  );
                  break;
                }
              }
            }
             
          return futureImage;
        }
        );


  }
 
  
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      constraints: BoxConstraints.expand(),
      child: _listView,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new AssetImage('assets/background_img.jpg'),
          fit: BoxFit.cover
          ),
      ),
);
      
  }
}

class EventCard extends StatelessWidget{
  final StorageReference storageReference;

  EventCard(BuildContext context, this.storageReference);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        constraints: BoxConstraints.expand(
          height: 400
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(32),
          ),color: Colors.white,
        boxShadow: [
          BoxShadow(
          blurRadius: 8,  
          spreadRadius: 4,
          color: Colors.black45
        )
        ],
      ),
            child: StreamBuilder(
          stream: storageReference.getDownloadURL().asStream(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
            var futureImage;
            if(snapshot.hasError){
              futureImage = Text('${snapshot.error}');
            }else{
              switch(snapshot.connectionState){
                case ConnectionState.none: {
                  futureImage = Text('Waiting');
                  break;
                }
                case ConnectionState.waiting: {
                  futureImage = Text('Waiting');
                  break;
                }
                case ConnectionState.active: {
                  futureImage = Text('Connecting');
                  break;
                }
                case ConnectionState.done: {
                  futureImage = ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                    child: Image.network(snapshot.data.toString(),
                    fit: BoxFit.fill)
                    );
                    
                }
              }
            }
            return futureImage;
          },
        )
        ),
    );
  }
}
