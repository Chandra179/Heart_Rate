import 'package:flutter/material.dart';
import 'package:heart_rate/pages/auth.dart';
import 'package:heart_rate/pages/login.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(children: <Widget>[
            Text("Profile"),
            RaisedButton(
              child: Text("Log Out"),
              onPressed: () async {
                await Auth.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()));

                });
                
              },
            ),
          ],
        )
      )
    );
  }
}
