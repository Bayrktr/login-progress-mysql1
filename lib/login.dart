import 'package:akillimenum/mainPage.dart';
import 'package:akillimenum/mysqlFunctions.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'main.dart';

void main() {
  runApp(LoginDemo());
}

class LoginDemo extends StatefulWidget {
  LoginDemo({Key});

  @override
  _LoginDemo createState() => _LoginDemo();
}

class _LoginDemo extends State<LoginDemo> {
  var username;
  var password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Akıllı Menum"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 100, bottom: 0),
              child: TextField(
                onChanged: (value) {
                  username = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  final db = await dbConnectSystem();
                  print(username);
                  print(password);
                  var passwordCheck = await loginSystem(username, password, db);
                  print(passwordCheck);
                  if (passwordCheck) {
                    final userMail = await userMailAdress(username, db);
                    print("geçti");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                mainPage(
                                    username: username,
                                    mail: userMail[0],
                                )));
                  } else {
                    print("geçemedi");
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
