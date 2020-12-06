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
      backgroundColor: Colors.blue,
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Daftar Akun', style: TextStyle(fontSize: 32, color: Colors.white)),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 300,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        Text('Nama', style: TextStyle(color: Colors.white, fontSize: 15),), 
                      TextField(
                        maxLength: 15,
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        fillColor: Colors.white,
                        filled: true,
                        counter: Offstage(),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.blue[800],
                          size: 30,
                          )
                      ),
                      controller: nameController,
                    ),
                  ]
                  ),
                ),
                Container(
                  width: 300,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        Text('Email', style: TextStyle(color: Colors.white, fontSize: 15),), 
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Your Email",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
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
                            Radius.circular(10.0),
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
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        Text('Umur', style: TextStyle(color: Colors.white, fontSize: 15),), 
                    TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      decoration: InputDecoration(
                        hintText: "Umur",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        fillColor: Colors.white,
                        filled: true,
                        counter: Offstage(),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.cake_outlined,
                          color: Colors.blue[800],
                          size: 30,
                          )
                      ),
                      controller: umurController,
                    ),
                      ]
                  ),
                ),
                Container(
                  width: 300,
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        Text('Jenis Kelamin', style: TextStyle(color: Colors.white, fontSize: 15),), 
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          hintText: "Gender",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.wc,
                          color: Colors.blue[800],
                          size: 30,
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
                      ]
                  ), 
                ),
                Container(
                  width: 300,
                    height: 50,
                    margin: const EdgeInsets.only(top: 15),
                  child: FlatButton(
                    child: Text("Register",style: TextStyle(color: Colors.blue),),
                    color: Colors.yellowAccent,
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
                ),
            ],
            )
          ),
        ),
      ),
    );
  }
}

class Gender{
  String type;
  Gender(this.type);
}