import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Exercise {
  String name;
  Exercise({this.name});
}

class AlertDialogWidget extends StatefulWidget {
  final int bpm;
  const AlertDialogWidget(this.bpm);

  @override
  _AlertDialogWidgetState createState() => new _AlertDialogWidgetState();
}

/// (widget.bpm).toString(),

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  int _selected;
  List<Exercise> exercises = [
    Exercise(name: 'A'),
    Exercise(name: 'B'),
    Exercise(name: 'C'),
    Exercise(name: 'D'),
    Exercise(name: 'E'),
    Exercise(name: 'F'),
    Exercise(name: 'G')
  ];

  var _myColor = false;
  var _myColor2 = false;
  var _myColor3 = false;

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Choose Activity'),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.white70, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: (_myColor
                                                          ? Colors.blue
                                                          : Colors.white),
                                                    )
                                                  ],
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 3.0,
                                                      color: Colors.white),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 3, 2),
                                                child: IconButton(
                                                    splashColor: Colors.yellow,
                                                    splashRadius: 20,
                                                    icon: Icon(
                                                      Icons.accessibility_sharp,
                                                      color: (_myColor
                                                          ? Colors.black
                                                          : Colors.grey),
                                                      size: 35,
                                                    ),
                                                    onPressed: () {
                                                      if (_myColor) {
                                                        setState(() {
                                                          _myColor = false;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _myColor = true;
                                                          _myColor2 = false;
                                                          _myColor3 = false;
                                                        });
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          child: Text(
                                            'General',
                                            style: new TextStyle(
                                              fontSize: 9.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.white70, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: (_myColor3
                                                          ? Colors.blue
                                                          : Colors.white),
                                                    )
                                                  ],
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 3.0,
                                                      color: Colors.white),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    2, 0, 3, 2),
                                                child: IconButton(
                                                    splashColor: Colors.yellow,
                                                    splashRadius: 20,
                                                    icon: Icon(
                                                      Icons.directions_run,
                                                      color: (_myColor3
                                                          ? Colors.black
                                                          : Colors.grey),
                                                      size: 35,
                                                    ),
                                                    onPressed: () {
                                                      if (_myColor3) {
                                                        setState(() {
                                                          _myColor3 = false;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _myColor3 = true;
                                                          _myColor = false;
                                                          _myColor2 = false;
                                                        });
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          child: Text(
                                            'Exercise',
                                            style: new TextStyle(
                                              fontSize: 9.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.white70, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: (_myColor2
                                                          ? Colors.blue
                                                          : Colors.white),
                                                    )
                                                  ],
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 3.0,
                                                      color: Colors.white),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    2, 0, 2, 2),
                                                child: IconButton(
                                                    splashColor: Colors.yellow,
                                                    splashRadius: 20,
                                                    icon: Icon(
                                                      Icons
                                                          .airline_seat_individual_suite_rounded,
                                                      color: (_myColor2
                                                          ? Colors.black
                                                          : Colors.grey),
                                                      size: 35,
                                                    ),
                                                    onPressed: () {
                                                      if (_myColor2) {
                                                        setState(() {
                                                          _myColor2 = false;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _myColor2 = true;
                                                          _myColor = false;
                                                          _myColor3 = false;
                                                        });
                                                      }
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          child: Text(
                                            'Rest',
                                            style: new TextStyle(
                                              fontSize: 9.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              TextField(
                                  autofocus: false,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 18),
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "hint",
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancel",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Continue",
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontWeight: FontWeight.w600, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () => showAlert(context),
        child: Text(
          'Tap to Show Alert Dialog Box',
        ),
        textColor: Colors.white,
        color: Colors.orangeAccent,
        padding: EdgeInsets.fromLTRB(
          10,
          10,
          10,
          10,
        ),
      ),
    );
  }
}
