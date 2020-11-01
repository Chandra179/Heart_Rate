import 'package:flutter/material.dart';
import 'package:heart_rate/pages/heartSensor.dart';
import 'package:intl/intl.dart';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main()=>runApp(Home());

class GoToHeartSensor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
      ),
      iconSize: 150,
      color: Colors.pink,
      splashRadius: 1,
      onPressed: () {
        // Navigator.pushNamed(context, '/heart');
        _awaitReturnValueFromSecondScreen(context);
      },
    );
  }

  _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HeartSensor(),
        ));

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
  }
}

class UserInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('dbuser');
    var now = new DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new Container(
              padding: EdgeInsets.fromLTRB(95, 0, 95, 10),
              child: Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.accessibility_sharp),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Text(document.data()['nama']),
                            Text('98'),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                            Icon(
                              Icons.favorite,
                              size: 18,
                              color: Colors.pink,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Rate'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
            alignment: Alignment.center,
            child: GoToHeartSensor(),
          ),
          Center(child: Text('Click Me')),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(100, 70, 70, 10),
            child: Text('Last Measurement'),
          ),
          Container(child: UserInformation()),
        ]),
    );
  }
}

