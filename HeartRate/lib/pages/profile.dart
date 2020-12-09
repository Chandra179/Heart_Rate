import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate/pages/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heart_rate/pages/faq.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:heart_rate/pages/login.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var firebaseUser;
  File _imageFile;

  @override
  void initState() {
    firebaseUser = FirebaseAuth.instance.currentUser;

    super.initState();
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    File selected = await ImagePicker.pickImage(source: source);
    ProgressDialog pr = ProgressDialog(context, isDismissible: false);
    pr.style(
        message: 'Upload file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    // firebase_storage.Reference ref =
    // firebase_storage.FirebaseStorage.instance.ref('images/${DateTime.now()}.png').putFile(_imageFile);
    String filePath = 'images/${DateTime.now()}.png';

    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref(filePath)
        .putFile(selected);
    pr.show();
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    // We can still optionally use the Future alongside the stream.
    try {
      await task;
      print('Upload complete.');
    } catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      // ...
    }

    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(filePath)
        .getDownloadURL();

    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .update({'photoURL': downloadURL}).then((value) {
      Navigator.pop(context);
      pr.hide();
    }).catchError((error) => print("Failed to update user: $error"));
    ;

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                _openPopup(context);
              },
            )
          ],
        ),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(firebaseUser.uid)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              (snapshot.data['photoURL'] != 'default')
                                  ? NetworkImage(snapshot.data['photoURL'])
                                  : AssetImage("assets/images/zoro.jpg"),
                          child: ClipOval(
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  height: 33,
                                  child: GestureDetector(
                                    onTap: () {
                                      print("clicked");
                                      // Select an image from the camera or gallery
                                      Alert(
                                        context: context,
                                        title: 'Change Picture',
                                        content: Column(
                                          children: <Widget>[
                                            FlatButton(
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  new Icon(Icons.camera),
                                                  new Text('   Take a Picture'),
                                                ],
                                              ),
                                              onPressed: () => _pickImage(
                                                  ImageSource.camera, context),
                                              color: Colors.transparent,
                                            ),
                                            FlatButton(
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  new Icon(Icons.photo_library),
                                                  new Text(
                                                      '   Select From Gallery'),
                                                ],
                                              ),
                                              onPressed: () => _pickImage(
                                                  ImageSource.gallery, context),
                                              color: Colors.transparent,
                                            ),
                                          ],
                                        ),
                                      ).show();
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 30,
                                      color: Color.fromRGBO(0, 0, 0, .74),
                                      child: Center(
                                        child: Icon(Icons.photo_camera,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return Text('');
                      }
                      return Text('');
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(firebaseUser.uid)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Flexible(
                          child: SizedBox(
                            width: 190,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    snapshot.data['name'],
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.wc,
                                        size: 15,
                                        color: Colors.lightBlue,
                                      ),
                                      Text(snapshot.data['gender'] + "    ",
                                          style: TextStyle(fontSize: 15.0)),
                                      Icon(
                                        Icons.cake_outlined,
                                        size: 15,
                                        color: Colors.lightBlue,
                                      ),
                                      Text(
                                        snapshot.data['umur'] + " Tahun",
                                        style: TextStyle(fontSize: 15.0),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return CircularProgressIndicator();
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
              child: ListView(children: <Widget>[
                Divider(
                  color: Colors.black12,
                  thickness: 0.5,
                  indent: 20,
                  endIndent: 20,
                ),
                buildListTile(Icons.contact_support, 'FAQ', context),
                buildListTile(Icons.people_alt_outlined, 'About Us', context),
                buildListTile(Icons.logout, 'Logout', context),
              ])),
        ])));
  }

//editProfile
  Widget _openPopup(context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    TextEditingController namaController = TextEditingController(text: "");
    TextEditingController umurController = TextEditingController(text: "");

    Gender selectedGender;
    List<Gender> genders = [Gender("Pria"), Gender("Wanita")];

    List<DropdownMenuItem> generateItems(List<Gender> genders) {
      List<DropdownMenuItem> items = [];
      for (var item in genders) {
        items.add(DropdownMenuItem(
          child: Text(item.type),
          value: item,
        ));
      }
      return items;
    }

    Alert(
        context: context,
        title: "Edit Profile",
        content: Column(
          children: <Widget>[
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(firebaseUser.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                selectedGender = (snapshot.data['gender'] == 'Pria')
                    ? genders[0]
                    : genders[1];
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          maxLength: 15,
                          controller: namaController
                            ..text = snapshot.data['name'],
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: "Name",
                            counter: Offstage(),
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          controller: umurController
                            ..text = snapshot.data['umur'],
                          decoration: InputDecoration(
                            icon: Icon(Icons.cake_outlined),
                            counter: Offstage(),
                            labelText: "Umur",
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.wc),
                            ),
                            value: (snapshot.data['gender'] == 'Pria')
                                ? genders[0]
                                : genders[1],
                            items: generateItems(genders),
                            onChanged: (item) {
                              selectedGender = item;
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Save Change",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              if (namaController.text.length > 15) {
                Fluttertoast.showToast(
                    msg: "Nama Max 15 Character",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(firebaseUser.uid)
                    .update({
                  'name': namaController.text,
                  'umur': umurController.text,
                  'gender': selectedGender.type
                }).then((value) {
                  Navigator.pop(context);
                }).catchError(
                        (error) => print("Failed to update user: $error"));
              }
            },
          )
        ]).show();
  }
}

ListTile buildListTile(leadingIcon, titleText, context) {
  if (titleText == "FAQ") {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(titleText),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Faq(),
          ),
        );
      },
    );
  }
  if (titleText == "About Us") {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(titleText),
      onTap: () async {
        const url = 'https://zicare.id';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }

  if (titleText == "Logout") {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: Colors.red,
      ),
      title: Text(
        titleText,
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {
        Auth.signOut().then((value) => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()))
            });
      },
    );
  }
}

class Gender {
  String type;
  Gender(this.type);
}

