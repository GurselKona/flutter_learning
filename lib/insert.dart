import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'userRecord.dart';

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _userID = TextEditingController();
  List users = [];
  List<UserRecord> userCls = [];

  void back() {
    Navigator.pop(context);
  }

  Future<void> addRecord() async {
    Database db = await openDatabase("db_AOF");

    /* Add new record via standard JSON
    var user = {"FIRST_NAME": _firstName.text, "LAST_NAME": _lastName.text};
    int userID = await db.insert("USERS", user);*/

    // Add new record via userRecord class
    UserRecord user =
        UserRecord(firstname: _firstName.text, lastname: _lastName.text);
    int userID = await db.insert("USERS", user.toJson());
    print("Yeni kayıt eklendi: $userID");
    getAllRecords();
    db.close();
  }

  Future<void> getAllRecords() async {
    Database db = await openDatabase("db_AOF");

    /*//Get all record without using class.
    users = await db.rawQuery("SELECT * FROM USERS");*/

    //Get all records via UserRecord class.

    userCls = List<UserRecord>.from((await db.rawQuery("SELECT * FROM USERS"))
        .map((e) => UserRecord.fromJson(e)));

    db.close();
    setState(() {});
    print(users);
  }

  Future<void> getOneRecord() async {
    Database db = await openDatabase("db_AOF");

    users = await db
        .rawQuery("SELECT * FROM USERS WHERE ID=?", [int.parse(_userID.text)]);
    _firstName.text = users.elementAt(0)["FIRST_NAME"].toString();
    _lastName.text = users.elementAt(0)["LAST_NAME"].toString();
    _userID.text = users.elementAt(0)["ID"].toString();

    db.close();
  }

  void updateRecord() async {
    Database db = await openDatabase("db_AOF");

    /*//Update without using class.
    int count = await db.rawUpdate(
        "UPDATE USERS SET FIRST_NAME = ?, LAST_NAME = ? WHERE ID = ?",
        [_firstName.text, _lastName.text, _userID.text]);*/

    //Update using UserRecord class.

    UserRecord user = UserRecord(
        id: int.parse(_userID.text),
        firstname: _firstName.text,
        lastname: _lastName.text);
    int count = await db.update("USERS", user.toJson(),
        where: "ID=?", whereArgs: [int.parse(_userID.text)]);

    db.close();
    print("Güncellenen kayıt sayısı: $count");
    getAllRecords();
  }

  void delRecord() async {
    Database db = await openDatabase("db_AOF");
    int count = await db
        .rawDelete("DELETE FROM USERS WHERE ID =?", [int.parse(_userID.text)]);
    db.close();
    print("Silinen kayıt sayıs: $count");
    getAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Kayıt Girişi")),
      body: Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _userID,
            ),
            TextFormField(
              controller: _firstName,
            ),
            TextFormField(
              controller: _lastName,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: back,
                  child: const Text(
                    "Geri",
                  ),
                ),
                TextButton(
                  onPressed: addRecord,
                  child: const Text(
                    "Kaydet",
                  ),
                ),
                TextButton(
                  onPressed: getAllRecords,
                  child: const Text(
                    "Kayıtları Getir",
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: updateRecord,
                  child: const Text(
                    "Güncelle",
                  ),
                ),
                TextButton(
                  onPressed: delRecord,
                  child: const Text("Kaydı Sil"),
                ),
                TextButton(
                  onPressed: getOneRecord,
                  child: const Text(
                    "Kaydı getir",
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userCls.length,
                itemBuilder: (context, index) {
                  return Row(children: [
                    Text("${userCls[index].id} "),
                    Text("${userCls[index].firstname} "),
                    Text("${userCls[index].lastname} "),

                    // The following code works for classless usage

                    /*Text("${users.elementAt(index)["ID"]} "),
                    Text("${users.elementAt(index)["FIRST_NAME"]} "),
                    Text("${users.elementAt(index)["LAST_NAME"]} "),*/
                  ]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
