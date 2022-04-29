import 'package:flutter/material.dart';
import 'package:testing_app/login.dart';
import 'package:testing_app/register.dart';

void main() {
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
