import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_app/login.dart';
import 'package:testing_app/register.dart';
import 'package:local_auth/local_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text("Hello"),
              centerTitle: true,
            ),
            body: Builder(
                builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Login
                          MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginApp()));
                            },
                            color: Colors.deepPurple[400],
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(40)),
                            child:
                                Text("Login", style: TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(height: 15),
                          //Biometric
                          MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterApp()));
                              },
                              color: Colors.deepPurple[300],
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.deepPurple),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text("Biometric Login",
                                  style: TextStyle(fontSize: 20))),
                          const SizedBox(height: 15),
                          //Register
                          MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterApp()));
                              },
                              color: Colors.deepPurple[200],
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.deepPurple),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text("Register",
                                  style: TextStyle(fontSize: 20)))
                        ]))));
  }
}
