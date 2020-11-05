import 'package:flutter/material.dart';
import 'package:heart_rate/pages/auth.dart';
import 'package:heart_rate/pages/login.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
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

  bool _passwordVisible;

  @override
  void initState(){
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Register",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              width: 300,
              height: 100,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Your Name",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    )
                ),
                controller: nameController,
              ),
            ),
            Container(
              width: 300,
              height: 100,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Your Email",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    )
                ),
                controller: emailController,
              ),
            ),
            Container(
              width: 300,
              height: 100,
              child: TextField(
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  hintText: "Your Password",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.lock
                    ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,

                    ),
                    onPressed: () {
                     
                        setState((){
                          _passwordVisible = !_passwordVisible;
                        });
                     
                    },
                  ),
                ),
                controller: passwordController,
              ),
            ),
            Container(
              width: 300,
              height: 100,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Umur",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.toys,
                    )
                ),
                keyboardType: TextInputType.number,
                controller: umurController,
              ),
            ),
            Container(
              width: 300,
              height: 100,
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Gender",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.wc,
                    )
                  ),
                  value: selectedGender,
                  items: generateItems(genders),
                  onChanged: (item) {
                    setState(() {
                      selectedGender = item;
                    });
                  },
                ),
              ), 
            ),
            RaisedButton(
              child: Text("Register"),
              onPressed: () async {
                await Auth.signUp(emailController.text, passwordController.text, nameController.text, umurController.text, selectedGender.type).then((value) {
                  if(value != null){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()));
                  }else {
                     Fluttertoast.showToast(
                          msg: "Something Wrong",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                  }
                });
                  
                
            }),
        ],
        )
      ),
    );
  }
}

class Gender{
  String type;
  Gender(this.type);
}