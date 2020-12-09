import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ///INISIALISASI DATABASE
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  ///HALAMAN HOME
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      /// STREAMBUILDER UNTUK MEMBUAT LIST
      body: StreamBuilder(
          stream: getUsersInformationStreamSnapshots(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: const Text("Loading..."));
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildUserCard(context, snapshot.data.documents[index]));
          }),
    );
  }
}

///RETRIEVE INFORMASI USER DARI FIRESTORE
Stream<QuerySnapshot> getUsersInformationStreamSnapshots(
    BuildContext context) async* {
  final User user = FirebaseAuth.instance.currentUser;
  final uid = user.uid;

  yield* FirebaseFirestore.instance
      .collection('dbuser')
      .doc(uid)
      .collection('heart_rate')
      .orderBy('tanggal', descending: true)
      .snapshots();
}

///WIDGET UNTUK MENAMPILKAN CARD
Widget buildUserCard(BuildContext context, DocumentSnapshot heartdata) {
  return Card(
    elevation: 2,
    child: Column(
      children: <Widget>[
        ListTile(
          leading: Container(
              child: Builder(
                  builder: (context) {
                    if (heartdata['icon'] == 4) {
                      return Icon(
                        Icons.accessibility_sharp,
                        size: 18,);
                    } else if (heartdata['icon'] == 2){
                      return Icon(
                        Icons.airline_seat_individual_suite_rounded,
                        size: 18,);
                    } else {
                      return Icon(
                        Icons.directions_run,
                        size: 18,);
                    }
                  }
              )
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Container(
                  child: Builder(
                      builder: (context) {
                        if (heartdata['icon'] == 4) {
                          return Text('General');
                        } else if (heartdata['icon'] == 2){
                          return Text('Rest');
                        } else {
                          return Text('Exercise');
                        }
                      }
                  )
              ),
              new Text(heartdata['bpm'].toString()),
            ],
            ///RETRIEVE DATA
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                heartdata['tanggal'].toString(),
                ///RETRIEVE DATA
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
  );
}
