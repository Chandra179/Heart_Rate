import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);

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
      body: Container(
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(
                Icons.favorite,
              ),
              iconSize: 150,
              color: Colors.pink,
              splashRadius: 1,
              onPressed: () {
                Navigator.pushNamed(context, '/heart');
              },
            ),
          ),
          Center(child: Text('Click Me')),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(100, 70, 70, 10),
            child: Text('Last Measurement'),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(95, 0, 95, 10),
            child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.accessibility_sharp),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Exercise'),
                          Container(
                              child: Text('98')
                          ),
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
           ),

        ],),
      ),
    );
  }
}