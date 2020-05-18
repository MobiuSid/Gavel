import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsFragment extends StatefulWidget {
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
        stream: widget._db
            .collection('meetings')
            .document('5zn8voqJl9wTnc6JwpfQ')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          var futureImage;
          if (snapshot.hasError) {
            futureImage = Text('${snapshot.error}');
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                {
                  futureImage = Text('Waiting');
                  break;
                }
              case ConnectionState.waiting:
                {
                  futureImage = Text('Waiting');
                  break;
                }
              default:
                {
                  snapshot.data.data..forEach((k, v) => _fileList.add(v));
                  print(_fileList);
                  futureImage = ListView.builder(
                      itemCount: _fileList.length,
                      itemBuilder: (context, index) => EventCard(
                          context,
                          FirebaseStorage().ref().child('${_fileList[index]}'),
                          ValueKey('${_fileList[index]}'),
                          '${_fileList[index]}'));
                  break;
                }
            }
          }

          return futureImage;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: _listView,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/background_img.jpg'),
            fit: BoxFit.cover),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final StorageReference storageReference;
  final ValueKey _key;
  final String _tag;
  EventCard(BuildContext context, this.storageReference, this._key, this._tag);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          constraints: BoxConstraints.expand(height: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 8, spreadRadius: 4, color: Colors.black45)
            ],
          ),
          child: StreamBuilder(
            stream: storageReference.getDownloadURL().asStream(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              var futureImage;
              if (snapshot.hasError) {
                futureImage = Text('${snapshot.error}');
              } else {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    {
                      futureImage = Text('Waiting');
                      break;
                    }
                  case ConnectionState.waiting:
                    {
                      futureImage = Text('Waiting');
                      break;
                    }
                  case ConnectionState.active:
                    {
                      futureImage = Text('Connecting');
                      break;
                    }
                  case ConnectionState.done:
                    {
                      futureImage = ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: GestureDetector(
                            child: Hero(
                                tag: '${this._tag}',
                                child: Image.network(snapshot.data.toString(),
                                    fit: BoxFit.fill)),
                            onTap: () => Navigator.push(context,
                                new HeroDialogRoute(
                                    builder: (BuildContext context) {
                              return Center(
                                  child: CardExpansion(
                                      _tag, snapshot.data.toString()));
                            })),
                          ));
                    }
                }
              }
              return futureImage;
            },
          )),
    );
  }
}

class CardExpansion extends StatelessWidget {
  final _db = Firestore.instance;
  final _storageReference = FirebaseStorage().ref();
  final _tag;
  final _address;
  final _location = 'meeting_details';

  CardExpansion(this._tag, this._address);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    // TODO: implement build
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              child: Hero(
                  tag: '${this._tag}',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20),
                    child: ListView(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network('${this._address}',
                              fit: BoxFit.contain),
                        ),
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection('meeting_details')
                                .where('tag', isEqualTo: 'events_pics/1.png')
                                .snapshots(), //replace with _tag
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              var futureWidget;
                              if (snapshot.hasError) {
                                futureWidget = Text('${snapshot.error}');
                              } else {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    {
                                      futureWidget = Text('Waiting');
                                      break;
                                    }
                                  case ConnectionState.waiting:
                                    {
                                      futureWidget = Text('Waiting');
                                      break;
                                    }
                                  case ConnectionState.done:
                                    {
                                      break;
                                    }
                                  default:
                                    {
                                      var record = Record.fromSnapshot(
                                          snapshot.data.documents[0]);
                                      futureWidget = Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Theme: ${record._theme}',
                                                style: GoogleFonts.palanquin(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 4),
                                                  child: Text(
                                                    record._details,
                                                    style: GoogleFonts
                                                        .ptSansNarrow(),
                                                    textAlign: TextAlign.center,
                                                  )),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  iconWidget(
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.redAccent.shade400,
                                                      ),
                                                      record._location),
                                                  iconWidget(
                                                      Icon(
                                                        Icons.event_available,
                                                        color: Colors
                                                            .blue.shade900,
                                                      ),
                                                      '${record.date()}')
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              iconWidget(
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Colors.green,
                                                  ),
                                                  record.time(
                                                          record._startTime) +
                                                      ' - ' +
                                                      record.time(
                                                          record._endTime)),
                                            ],
                                          ));
                                    }
                                }
                              }
                              return futureWidget;
                            })
                      ],
                    ),
                  )),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8, spreadRadius: 8, color: Colors.black38)
                  ],
                  color: Colors.white),
            )));
  }

  Widget iconWidget(Icon icon, String text) {
    return Container(
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            SizedBox(
              width: 2,
            ),
            Text(text, style: GoogleFonts.ptSansNarrow())
          ],
        ));
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.white10.withOpacity(0.0);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;
}

class Record {
  final String _theme;
  final String _details;
  final String _location;
  final String _meetingLink;
  final Timestamp _startTime;
  final Timestamp _endTime;
  final DocumentReference reference;
  final String _tag;
  var _date;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['details'] != null),
        assert(map['end_time'] != null),
        assert(map['start_time'] != null),
        assert(map['end_time'] != null),
        assert(map['theme'] != null),
        assert(map['tag'] != null),
        this._theme = map['theme'],
        this._details = map['details'],
        this._startTime = map['start_time'],
        this._endTime = map['end_time'],
        this._location = map['location'],
        this._meetingLink = map['meeting link'],
        this._tag = map['tag'];

  String date() {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(_startTime.millisecondsSinceEpoch);
    return ('${dateTime.day}/' + '${dateTime.month}/' + '${dateTime.year}');
  }

  String time(Timestamp timestamp) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    final hour = dateTime.hour;
    final minutes = dateTime.minute;
    return hour.toString().padLeft(2, '0') +
        ':' +
        '${minutes.toString().padLeft(2, '0')}';
  }

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
