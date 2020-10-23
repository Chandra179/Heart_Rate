import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_lantern/flutter_lantern.dart';

class Flash extends StatefulWidget {
  @override
  _FlashState createState() => _FlashState();
}

class _FlashState extends State<Flash> {
  bool _hasFlash = false;
  bool _isOn = false;
  double _intensity = 1.0;

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    bool hasLamp = false;
    try {
      platformVersion = await Lantern.platformVersion;
      hasLamp = await Lantern.hasLamp;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _hasFlash = hasLamp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.pink),
      home: new Scaffold(
        appBar: new AppBar(title: new Text('Lantern plugin example')),
        body: new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('Device has flash: $_hasFlash\n Flash is on: $_isOn'),
                new Slider(value: _intensity, onChanged: _isOn ? _intensityChanged : null),
                new RaisedButton(onPressed: () async => await Lantern.flash(new Duration(seconds: 2)), child:  new Text("Flash for 2 seconds"))
              ]),
        ),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(_isOn ? Icons.flash_off : Icons.flash_on),
            onPressed: _turnFlash),
      ),
    );
  }

  Future _turnFlash() async {
    _isOn ? Lantern.turnOff() : Lantern.turnOn(intensity: _intensity);
    var f = await Lantern.hasLamp;
    setState((){
      _hasFlash = f;
      _isOn = !_isOn;
    });
  }

  _intensityChanged(double intensity) {
    Lantern.turnOn(intensity : intensity);
    setState((){
      _intensity = intensity;
    });
  }
}