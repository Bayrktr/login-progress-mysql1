
import 'package:akillimenum/mysqlFunctions.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(mainPage());
}

class mainPage extends StatefulWidget {
  mainPage({Key, this.username, this.mail});

  var mail;
  var username;

  @override
  _mainPage createState() => _mainPage();
}

class _mainPage extends State<mainPage> {
  List<bool> _selections = [true, false];
  String _scanBarcode = '';
  var newUsername;
  var newMailAdress;
  var isSelectedItem;
  var password;

  @override
  scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    bool codeCheck = false;
    final db = await dbConnectSystem();
    var codeList = await allCompanyCodes(db);
    setState(() {
      _scanBarcode = barcodeScanRes;
      print("code $_scanBarcode");
      for(var x in codeList){
        print(x);
        if(_scanBarcode == x){
          print("Succsesful");
          codeCheck = true;
          break;
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        width: 150,
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            TextField(
              onChanged: (value) {
                newUsername = value;
              },
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'New Username',
                  hintText: '${widget.username}',
                  hintStyle: TextStyle(fontSize: 12),
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontStyle: FontStyle.normal)),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
            ),
            Column(
              children: [
                TextField(
                  onChanged: (value) {
                    newMailAdress = value;
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'New MailAdress',
                      hintText: '${widget.mail}',
                      hintStyle: TextStyle(fontSize: 12),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontStyle: FontStyle.normal)),
                ),
                Padding(padding: EdgeInsets.all(12.0)),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Enter your password',
                      hintText: 'Are you sure it is correct :)))',
                      hintStyle: TextStyle(fontSize: 10),
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontStyle: FontStyle.normal)),
                ),
                Padding(padding: EdgeInsets.all(12.0)),
                ToggleButtons(
                  borderColor: Colors.black,
                  fillColor: Colors.white,
                  borderWidth: 2,
                  selectedBorderColor: Colors.red,
                  selectedColor: Colors.black,
                  borderRadius: BorderRadius.circular(2.0),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsetsDirectional.all(2.0),
                      child: Icon(Icons.notification_add),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.all(2.0),
                      child: Icon(Icons.notifications_off),
                    ),
                  ],
                  onPressed: (int index) {
                    if (_selections[index] == true) {
                      _selections[index] = false;
                      if (index == 0) {
                        _selections[1] = true;
                      } else {
                        _selections[0] = true;
                      }
                    } else {
                      _selections[index] = true;
                      if (index == 0) {
                        _selections[1] = false;
                      } else {
                        _selections[0] = false;
                      }
                    }
                    setState(() {
                      _selections[index];
                    });
                    print(_selections);
                  },
                  isSelected: _selections,
                ),
                Padding(padding: EdgeInsets.all(12.0)),
                Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 3,
                          color: Colors.blue,
                        )),
                    child: FlatButton(
                      color: Colors.white,
                      onPressed: () async {
                        String notification;
                        print(_selections[0]);
                        if (_selections[0]) {
                          notification = '1';
                        } else {
                          notification = '0';
                        }
                        final db = await dbConnectSystem();
                        bool check = await userReworkSystem(widget.username, newUsername,
                            newMailAdress, password, notification, db);
                        if(check == true){
                          if (newUsername != null || newUsername == "") {
                            setState(() {
                              widget.username = newUsername;
                            });
                          }
                          if (newMailAdress != null || newMailAdress == "") {
                            setState(() {
                              widget.mail = newMailAdress;
                            });
                          }
                        }
                      },
                      child: Text("Save"),
                    )),
              ],
            ),
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () async {
                await scanQR();
              },
              child: Icon(
                Icons.qr_code_2_outlined,
                size: 80,
                color: Colors.blue,
              ))
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        actions: [
          Positioned(
              top: 20,
              right: 20,
              child: Builder(
                builder: (context) {
                  return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                        size: 30,
                      ));
                },
              )),
        ],
      ),
    );
  }
}
