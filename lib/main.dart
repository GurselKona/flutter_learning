import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'insert.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => const Begin(),
        "/insert": (context) => const Insert()
      },
    );
  }
}

class Begin extends StatefulWidget {
  const Begin({super.key});

  @override
  State<Begin> createState() => _BeginState();
}

class _BeginState extends State<Begin> {
  newRecord() {
    Navigator.pushNamed(context, "/insert");
  }

  Future<void> dbOlustur() async {
    Database db = await openDatabase(
      "db_AOF",
      version: 1,
      onCreate: (db, version) {
        print("onCreate çalıştı");
      },
      onUpgrade: (db, oldVersion, newVersion) => print("onUpgrade çalıştı"),
      onDowngrade: (db, oldVersion, newVersion) => print("onDowngrade çalıştı"),
    );
    db.close();
    print("dbOlustur çalıştı");
  }

  Future<void> dbVersionDegistir() async {
    Database db = await openDatabase("db_AOF");
    db.setVersion(11);
    print("Versiyon değişti");
    db.close();
  }

  Future<void> dbTabloOlustur() async {
    Database db = await openDatabase("db_AOF");

    db.execute(
        "CREATE TABLE USERS (ID INTEGER PRIMARY KEY, FIRST_NAME TEXT, LAST_NAME TEXT)");
    print("Tablo Oluştu");
    db.close();
  }

  Future<void> _deleteDatabase() async {
    await openDatabase('db_AOF');
    await databaseFactory.deleteDatabase('db_AOF');
    print("veritabanı tamamen silindi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Veritabanı oluşturma")),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              TextButton(
                onPressed: dbOlustur,
                child: const Text("Veritabanı Oluştur"),
              ),
              TextButton(
                onPressed: dbVersionDegistir,
                child: const Text("Veritabanı Versiyon Değiştir"),
              ),
              TextButton(
                onPressed: dbTabloOlustur,
                child: const Text("Yeni Tablo Oluştur"),
              ),
              TextButton(
                onPressed: newRecord,
                child: const Text("Yeni Kayıt Sayfasına Git"),
              ),
              TextButton(
                onPressed: _deleteDatabase,
                child: const Text("VERITABANINI SIL!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
