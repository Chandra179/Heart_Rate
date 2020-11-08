import 'package:flutter/material.dart';
//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main()=>runApp(Home());

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
      body: ListView(
          children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(100, 70, 70, 10),
            child: Text('Last Measurement'),
          ),
         StreamBuilder(
                stream: getUsersInformationStreamSnapshots(context),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return Center(child: const Text("Loading..."));
                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildUserCard(context, snapshot.data.documents[index]));
                }),
        ]),
    );
  }
}

Stream<QuerySnapshot> getUsersInformationStreamSnapshots(BuildContext context) async* {
  final User user = FirebaseAuth.instance.currentUser;
  final uid = user.uid;

  yield* FirebaseFirestore.instance
      .collection('dbuser')
      .doc(uid)
      .collection('heart_rate')
      .orderBy('tanggal', descending: true)
      .snapshots();
}

Widget buildUserCard(BuildContext context, DocumentSnapshot heartdata) {
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
                    new Text("Exercise"),
                    new Text(heartdata['bpm'].toString()),
                  ], ///RETRIEVE DATA
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      heartdata['tanggal'].toString(), ///RETRIEVE DATA
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    Icon(
                      Icons.favorite,
                      size: 18,
                      color: Colors.pink,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
  );
}