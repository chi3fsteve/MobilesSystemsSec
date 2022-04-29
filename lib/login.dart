import 'package:flutter/material.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
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
          onPressed: () {
            if (_key.currentState!.validate()) {
              _key.currentState!.save();
              print("form submitted");
            }
          },
        ),
      ),
    );
  }
}
