import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes.dart';

void main() {
  runApp(App());
}

final primaryColor = Color.fromRGBO(50, 58, 84, 1);
final accentColor = Color.fromRGBO(237, 122, 64, 1);
final backgroundColor = Color.fromRGBO(236, 237, 240, 1.0);
final cardColor = Colors.white;


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(backgroundColor: Colors.red,),
              width: 60,
              height: 60,
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return CreativeQuest();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
        );
      },
    );
  }
}




class CreativeQuest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CreativeQuest',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        cardColor: cardColor,
        fontFamily: 'Grotesk',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Grotesk',
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
              fontSize: 64.0, fontWeight: FontWeight.bold, color: Colors.white),
          headline3: TextStyle(
              fontSize: 94.0, fontWeight: FontWeight.bold, color: accentColor),
          headline4: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          headline5: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          headline6: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyText1: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Grotesk',
            color: primaryColor,
          ),
          bodyText2: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Grotesk',
            color: accentColor,
          ),
          button: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      onGenerateRoute: CreativeRouter.generateRoute,
    );
  }
}
