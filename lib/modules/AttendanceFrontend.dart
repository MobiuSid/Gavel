
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() => runApp(MaterialApp(
    home: Scaffold(
body:AttendanceSheet()
    )
));

class AttendanceSheet extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AttendanceSheetState();

}

class AttendanceSheetState extends State<AttendanceSheet>{
  Widget _buildListItem(BuildContext context, DocumentSnapshot data){
    var record = Record.fromSnapshot(data);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        key: ValueKey(record.name),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(record.name),
            trailing: Checkbox(
              onChanged:
                (bool value) {
                setState(() {
                  data.reference.updateData({"17-03-2020": value});
                });
            },
              value: record.presence,
            ),
          ),
        )
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Attendance').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

}


class Record {
  final String name;
  bool presence;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Name'] != null),
        assert(map['17-03-2020'] != null),
        name = map['Name'],
        presence = map['17-03-2020'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

  @override
  String toString() => "Record<$name:$presence>";
}




