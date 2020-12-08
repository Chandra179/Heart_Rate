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
  void initState() {
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
      backgroundColor: Colors.blue,
      body:SingleChildScrollView(
        child: Container(
          child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 70),
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/images/logo.png"),
                      width: 200,
                      height: 70,
                    ),
                    Container(
                      width: 300,
                      height: 100,
                      margin: const EdgeInsets.only(top:40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                        Text('Emails', style: TextStyle(color: Colors.white, fontSize: 15),), 
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Your Email",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.blue[800],
                              size: 30,
                              )
                          ),
                          controller: emailController,
                        ),
                        ]
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 100,
                      margin: const EdgeInsets.only(bottom:30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [ 
                        Text('Password', style: TextStyle(color: Colors.white, fontSize: 15),), 
                        TextField(
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: "Your Password",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.blue[800],
                              size: 30,
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
                        ]
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 50,
                      child: FlatButton(
                        child: Text("MASUK", style: TextStyle(color: Colors.blue),),
                        color: Colors.yellowAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide.none
                        ),
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
                    ),
                    Container(
                      width: 300,
                      height: 50,
                      margin: const EdgeInsets.only(top: 15),
                      child: FlatButton(
                        child: Text("DAFTAR AKUN BARU", style: TextStyle(color: Colors.yellowAccent),),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.yellowAccent, width: 2)
                        ),
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                        },
                      ),
                    ),
                ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
