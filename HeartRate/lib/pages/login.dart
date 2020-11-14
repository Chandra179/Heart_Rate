import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heart_rate/pages/auth.dart';
import 'package:heart_rate/pages/menu.dart';
import 'package:heart_rate/pages/register.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

enum AuthStatus {
  notSignedIn,
  signedIn
}

class _Login extends State<Login> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool _passwordVisible;

  @override
  void initState() async {
     Auth.currentUser().then((user) {
      if (user != null) { //if there isn't any user currentUser function returns a null so we should check this case. 
        Navigator.pushAndRemoveUntil(
            // we are making YourHomePage widget the root if there is a user.
            context,
            MaterialPageRoute(builder: (context) => Menu()),
            (Route<dynamic> route) => false);
      }
    });
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
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
            RaisedButton(
              child: Text("Log in"),
              onPressed: () async {
                await Auth.signIn(emailController.text, passwordController.text).then((user) {
                  if(user != null){
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Menu()));
                  }else {
                    Fluttertoast.showToast(
                          msg: "Wrong Email or Password",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an Account? ",
                ),
                GestureDetector(
                  onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                ),
              ],
            )
        ],
        )
      ),
    );
  }
}
