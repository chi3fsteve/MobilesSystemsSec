import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testing_app/db_connection.dart';

class RegisterApp extends StatefulWidget {
  const RegisterApp({Key? key}) : super(key: key);

  @override
  _RegisterAppState createState() => _RegisterAppState();
}

class _RegisterAppState extends State<RegisterApp> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _passConf = TextEditingController();
  final DatabaseConnection _databaseConnection = DatabaseConnection();
  late Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Register below'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context))),
        body: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  String emailPattern =
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  if (!RegExp(emailPattern).hasMatch(value))
                    return 'Wrong email address pattern';
                  return null;
                },
              ),
              TextFormField(
                controller: _pass,
                decoration: const InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  String passwordPattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  if (!RegExp(passwordPattern).hasMatch(value)) {
                    return '''
The password has to be at least 8 characters,
include a capital letter, a number and a symbol
                      ''';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passConf,
                decoration:
                    const InputDecoration(labelText: "Confirm Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  if (value != _pass.text) {
                    return "Passwords don't match";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.login),
          onPressed: () {
            if (_key.currentState!.validate()) {
              _key.currentState!.save();
              print("form submitted");
              String email = _email.text;
              String pass = _pass.text;
              Map<String, dynamic> row = {'email': email, 'password': pass};
              insertData('users', row);
            }
          },
        ),
      ),
    );
  }
}