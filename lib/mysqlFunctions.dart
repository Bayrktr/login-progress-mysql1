import 'package:mysql1/mysql1.dart';

var settingsSystem = new ConnectionSettings(
    host: '20.0.0.2',
    port: 3306,
    user: 'root',
    password: '12345',
    db: 'system');

Future<MySqlConnection> dbConnectSystem() async {
  return await MySqlConnection.connect(settingsSystem);
}

allUsers(db) async {
  var usernames = [];
  var results = await db.query('select name from userrecords');
  for (var x in results) {
    usernames.add(x);
  }
  return usernames;
}

userMailAdress(username, db) async {
  var mailAdress = [];
  var result =
      await db.query('select mail from userrecords where name = ?', [username]);
  for (var x in result) {
    mailAdress.add(x[0]);
  }
  db.close();
  return mailAdress;
}

loginSystem(username, password, db) async {
  print("username = $username");
  password = password.toString();
  bool usernameCheck = false;
  var users = await allUsers(db);
  if (users.isEmpty) {
    print("");
  } else {
    for (var x in users) {
      print("x = ${x[0]}");
      print("$username");
      if (x[0].toString() == username.toString()) {
        usernameCheck = true;
        break;
      }
    }
    if (usernameCheck) {
      var passwordList = [];
      var correctPassword = await db
          .query('select password from userrecords where name = "$username"');
      for (var x in correctPassword) {
        passwordList.add(x[0]);
      }
      if (passwordList[0].toString() == password.toString()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

userReworkSystem(
    username, newUsername, newMailAdress, password, notification, db) async {
  var a = [username, newUsername, newMailAdress, password, notification, db];
  for (var x in a) {
    print(x);
  }
  bool usernameFill = true;
  bool mailAdressFill = true;
  if (await loginSystem(username, password, db) == true) {
    if (newUsername == null) {
      usernameFill = false;
    }
    if (newMailAdress == null) {
      mailAdressFill = false;
    }
    if (usernameFill == true && mailAdressFill == true) {
      String words = 'update userrecords set name = "$newUsername",mail = "$newMailAdress",mailmessage = "$notification"';
      await EveryNewRecord(username, newUsername, db, words);
    } else if (usernameFill == false) {
      String words = 'update userrecords set mail = "$newMailAdress",mailmessage = "$notification"';
      await EveryNewRecord(username, newMailAdress, db, words);
    } else if (mailAdressFill == false) {
      String words = 'update userrecords set name = "$newUsername",mailmessage = "$notification"';
      await EveryNewRecord(username, newUsername, db, words);
    } else {
      String words = 'update userrecords set mailmessage = "$notification"';
      await EveryNewRecord(username, newUsername, db, words);
    }
    return true;
  }
  else {
    print("notaccetable");
    return false;
  }
}

allCompanyCodes(db) async{
  var codeList = [];
  var result = await db.query('select code from companyrecords');
  for(var x in result){
    codeList.add(x[0]);
  }
  return codeList;
}

EveryNewRecord(username, newUsername, db, words) async {
  var result = await db.query(words.toString());
}
