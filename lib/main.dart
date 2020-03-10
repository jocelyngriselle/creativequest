import 'package:flutter/material.dart';
import 'home_page.dart';
//import 'package:firebase/firebase.dart';

void main() {
  /* initializeApp(
      apiKey: "YourApiKey",
      authDomain: "YourAuthDomain",
      databaseURL: "YourDatabaseUrl",
      projectId: "YourProjectId",
      storageBucket: "YourStorageBucket");*/

  runApp(CreativeQuest());
}

class CreativeQuest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreativeQuest',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(64, 64, 64, 1),
        accentColor: Color.fromRGBO(64, 64, 64, 1),
        backgroundColor: Color.fromRGBO(73, 73, 73, 1),
        fontFamily: 'Grotesk',
        textTheme: TextTheme(
          display1: TextStyle(
            fontSize: 42.0,
            fontFamily: 'Grotesk',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          title: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
          subtitle: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
          body1: TextStyle(
              fontSize: 14.0, fontFamily: 'Grotesk', color: Colors.white),
          display2: TextStyle(
              fontSize: 28.0, fontFamily: 'Grotesk', color: Colors.white),
          headline: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomePage(),
    );
  }
}
