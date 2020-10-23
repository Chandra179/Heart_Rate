import 'package:flutter/material.dart';
import 'package:heart_rate/component/barChart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              onPressed: () {},
            ),
          ),
          Center(child: Text('Click Me')),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(100, 70, 70, 10),
            child: Text('Recently'),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(95, 0, 70, 10),
            child: Card(
              child: Column(
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.access_alarms),
                    title: Text('Exercise'),
                    subtitle: Text('Cycling through deep jungle in midnight'),
                  )
                ],
              )
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(100, 40, 70, 10),
            child: Text('Heart Monitor'),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(95, 10, 70, 10),
            child: BarChartSample3(),
          )

        ],),
      ),

    );
  }
}