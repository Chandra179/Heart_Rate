import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate/pages/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:heart_rate/pages/login.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
bool isLoading = true;

@override
  void initState()  {
    
  super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/zoro.jpg"),
                    child: ClipOval(
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            height: 33,
                            child: GestureDetector(
                              onTap: (){
                                print('upload Clicked');
                              },
                              child: Container(
                                height: 20,
                                width: 30,
                                color: Color.fromRGBO(0, 0, 0, .74),
                                child: Center(
                                  child: Icon(Icons.photo_camera, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                    FutureBuilder(
                      future: getUserInfo(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title:
                                      Text(
                                        snapshot.data['name'],
                                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                        
                                          ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.wc,
                                        size: 15,
                                        color: Colors.lightBlue,
                                      ),
                                      Text(
                                        snapshot.data['gender'] +"    ",
                                        style: TextStyle(fontSize: 15.0)
                                      ),
                                      Icon(
                                        Icons.verified_user,
                                        size: 15,
                                        color: Colors.lightBlue,
                                      ), 
                                      Text (
                                        snapshot.data['umur'] + " Tahun",
                                        style: TextStyle(fontSize: 15.0),
                                      )
                                    ],
                                    )  
                                );
                              },
                              );
                        } else if (snapshot.connectionState == ConnectionState.none) {
                          return Text("No data");
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                
                ],
              
              ),
              ),
              ),
            Expanded(
              flex: 6,
              child:  ListView(
                children: <Widget>[
                  Divider(
                    color: Colors.black12,
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 20,
                  ),
                  buildListTile(Icons.contact_support, 'FAQ', context),
                  buildListTile(Icons.settings, 'Setting', context),
                  buildListTile(Icons.monetization_on, 'Donate Please', context),
                  buildListTile(Icons.logout, 'Logout', context),

                ]
              )
              ),
              
          ]
        )
      )
    );
}

}

Future<DocumentSnapshot> getUserInfo()async{
  var firebaseUser = await FirebaseAuth.instance.currentUser;
  return await FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).get();
}

ListTile buildListTile(leadingIcon, titleText, context) {
    if(titleText == "FAQ"){
      return ListTile(
            leading: Icon(leadingIcon),
            title: Text(titleText),
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(),
                  ),
            );
          },
        );
      }
      if(titleText == "Setting"){
        return ListTile(
            leading: Icon(leadingIcon),
            title: Text(titleText),
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(),
                  ),
            );
          },
        );
      }
      if(titleText == "Donate Please"){
        return ListTile(
            leading: Icon(leadingIcon),
            title: Text(titleText),
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(),
                  ),
            );
          },
        );
      }

      if(titleText == "Logout"){
        return ListTile(
            leading: Icon(leadingIcon, color: Colors.red,),
            title: Text(titleText, style: TextStyle(color: Colors.red),),
            onTap: () {
            Auth.signOut().then((value) => {
              Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()))
            });
          },
        );
      }

    
  }

// Stream getUserInformationStreamSnapshots(
//     BuildContext context) async* {
//   final User user = FirebaseAuth.instance.currentUser;
//   final uid = user.uid;

//    yield* FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .snapshots();
// }

// Widget buildUserProfile(BuildContext context, DocumentSnapshot profileData){
 
// }

