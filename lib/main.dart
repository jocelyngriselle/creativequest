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

  runApp(MyApp());}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreativeQuest',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFBB4602, color),
        backgroundColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}


Map<int, Color> color =
{
  50:Color.fromRGBO(187,70,2, .1),
  100:Color.fromRGBO(187,70,2, .2),
  200:Color.fromRGBO(187,70,2, .3),
  300:Color.fromRGBO(187,70,2, .4),
  400:Color.fromRGBO(187,70,2, .5),
  500:Color.fromRGBO(187,70,2, .6),
  600:Color.fromRGBO(187,70,2, .7),
  700:Color.fromRGBO(187,70,2, .8),
  800:Color.fromRGBO(187,70,2, .9),
  900:Color.fromRGBO(187,70,2, 1),
};