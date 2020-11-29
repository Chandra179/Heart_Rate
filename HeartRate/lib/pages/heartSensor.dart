import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wakelock/wakelock.dart';
import '../component/chart.dart';
import 'package:heart_rate/pages/userData.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heart_rate/pages/popupDialog.dart';

///----------------------------------------------------------------------------------------------------------------------------------------------------------

class HeartSensor extends StatefulWidget {
  @override
  _HeartSensorState createState() => _HeartSensorState();
}

class _HeartSensorState extends State<HeartSensor>
    with SingleTickerProviderStateMixin {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _toggled = false; // toggle button value
  List<SensorValue> _data = List<SensorValue>(); // array to store the values
  CameraController _controller;
  double _alpha = 0.3; // factor for the mean value
  AnimationController _animationController;
  double _iconScale = 1;
  int _bpm = 0; // beats per minute
  int _fs = 30; // sampling frequency (fps)
  int _windowLen = 30 * 6; // window length to display - 6 seconds
  CameraImage _image; // store the last camera image
  double _avg; // store the average value during calculation
  DateTime _now; // store the now Datetime
  Timer _timer; // timer for image processing
  bool _Saveme = false; //Save data to dbase
  bool _ShowGraph = false;

  String tanggal = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
  var _myColor = false;
  var _myColor2 = false;
  var _myColor3 = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController
      ..addListener(() {
        setState(() {
          _iconScale = 1.0 + _animationController.value * 0.4;
        });
      });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(105, 0, 0, 0),
            child: Text('Scan'),
          ),
          leading: Visibility(
            visible: _Saveme,
            child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _Saveme = false;
                    _bpm = 0;
                  });
                },
              ),
          ),
          elevation: 4,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
              child: Visibility(
                visible: _Saveme,
                child: Container(
                  color: Colors.blue,
                  child: IconButton(
                    icon: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final myIcon = _iconController();
                      final User user = FirebaseAuth.instance.currentUser;
                      final uid = user.uid;
                      await db
                          .collection("dbuser")
                          .doc(uid)
                          .collection("heart_rate")
                          .add(Heart(tanggal, _bpm.toString(), myIcon)
                          .toJson());

                      setState(() {
                        _Saveme = false;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            ///BPM INDICATOR
            Container(
              padding: EdgeInsets.fromLTRB(0, 70, 0, 50),
              child: RawMaterialButton(
                onPressed: () {
                  if (_toggled) {
                    _untoggle();
                  } else {
                    _toggle();
                  }
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Column(
                  children: [
                    Text(
                      (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "0"),
                      style:
                          TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text('Bpm',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          child: Icon(
                            Icons.favorite,
                            size: 15,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(70, 70, 70, 70),
                shape: CircleBorder(
                  side: BorderSide(color: Colors.blue, width: 8),
                ),
              ),
            ),

            ///SHOWING LINE CHART OF SCANNING PROCESS
            Visibility(
              visible: _ShowGraph,
              child: Container(
                child: SizedBox(
                  height: 100,
                  width: 150,
                  child: Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        color: Colors.white),
                    child: Chart(_data),
                  ),
                ),
              ),
            ),

            ///ALERT
            Container(
              child: AlertDialogWidget(_bpm),
            ),

            ///SAVE TO DATABASE
            Visibility(
                visible: _Saveme,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: [
                              Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: BorderRadius.circular(40),
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
                                            width: 3.0, color: Colors.white),
                                      ),
                                      padding: EdgeInsets.fromLTRB(0, 0, 3, 2),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                  borderRadius: BorderRadius.circular(40),
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
                                            width: 3.0, color: Colors.white),
                                      ),
                                      padding: EdgeInsets.fromLTRB(2, 0, 3, 2),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                  borderRadius: BorderRadius.circular(40),
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
                                            width: 3.0, color: Colors.white),
                                      ),
                                      padding: EdgeInsets.fromLTRB(2, 0, 2, 2),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                  ],
                ))
          ],
        ));
  }

  void _clearData() {
    // create array of 128 ~= 255/2
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  void _toggle() {
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController?.repeat(reverse: true);
      setState(() {
        _toggled = true;
        _Saveme = false;
        _ShowGraph = true;
        _myColor = false;
        _myColor2 = false;
        _myColor3 = false;
        _bpm = 0;
      });
      // after is toggled
      _initTimer();
      _updateBPM();
    });
  }

  void _untoggle() {
    _disposeController();
    Wakelock.disable();
    _animationController?.stop();
    _animationController?.value = 0.0;
    setState(() {
      _toggled = false;
      _ShowGraph = false;
      _Saveme = true;
    });
  }

  int _iconController() {
    if (_myColor) {
      return 4;
    } else if (_myColor2) {
      return 2;
    } else if (_myColor3){
      return 9;
    } else {
      return 0;
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  ///CAMERA CONTROLLER
  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);
      await _controller.initialize();
      // Future.delayed(Duration(milliseconds: 100)).then((onValue) {
      //   _controller.flash(true);
      // });
      _controller.startImageStream((CameraImage image) {
        _image = image;
      });
    } catch (Exception) {
      debugPrint(Exception);
    }
  }

  ///HEART SCANNING TIMER
  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image);
      } else {
        timer.cancel();
      }
    });
  }

  /// calculates the average of the camera image’s red channel, and adds the value to the data list
  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now, _avg));
    });
  }

  ///CALCULATE BPM
  void _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        setState(() {
          this._bpm = ((1 - _alpha) * _bpm + _alpha * _bpm).toInt();
        });
      }
      await Future.delayed(Duration(
          milliseconds:
              1000 * _windowLen ~/ _fs)); // wait for a new set of _data values
    }
  }
}
