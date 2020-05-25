//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'action_page.dart';
//import 'action.dart';
//import 'dart:math';
//
//class HomePage extends StatelessWidget {
//  Future<QuerySnapshot> getData() {
//    return Future<QuerySnapshot>.delayed(
//      Duration(seconds: 3),
//      () => Firestore.instance.collection('fl_content').getDocuments(),
//    );
//  }
//
//  List<Action> getIdeaTypes(List<DocumentSnapshot> data) {
//    List<DocumentSnapshot> ideaTypesSnapshots =
//        data.where((i) => i.data["_fl_meta_"]["schema"] == "ideatype").toList();
//    print(ideaTypesSnapshots);
//    List<Action> ideaTypes = [];
//
//    for (var ideaTypeSnapshot in ideaTypesSnapshots) {
//      print(data[0].data);
//      print(data[0].metadata);
//      print(ideaTypeSnapshot.documentID);
//      List<DocumentSnapshot> ideasSnapshots = data
//          .where((i) =>
//              i.data["_fl_meta_"]["schema"] == "idea" &&
//              i.data["type"].documentID == ideaTypeSnapshot.documentID)
//          .toList();
//
//      var ideaType = Action.fromSnapshot(ideaTypeSnapshot, ideasSnapshots);
//      ideaTypes.add(ideaType);
//    }
//    return ideaTypes;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    getData().then((value) => Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//                  IdeaTypesPage(actions: getIdeaTypes(value.documents))),
//        ));
//    return Scaffold(
//      backgroundColor: Theme.of(context).backgroundColor,
//      body: SafeArea(
//        child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              SizedBox(
//                height: 30,
//              ),
//              SizedBox(
//                  height: min((MediaQuery.of(context).size.height) / 2,
//                      MediaQuery.of(context).size.width * 0.9),
//                  width: min((MediaQuery.of(context).size.height) / 2,
//                      MediaQuery.of(context).size.width * 0.9),
//                  child: Image.asset('assets/images/tape-recorder-decorated.png')),
//              Text(
//                "Creative".toUpperCase(),
//                style: Theme.of(context).textTheme.headline2,
//              ),
//              Text(
//                "Hacks".toUpperCase(),
//                style: Theme.of(context).textTheme.headline3,
//              ),
//              Text(
//                "Music Production Coach",
//                style: Theme.of(context).textTheme.headline1,
//              ),
//            ]),
//      ),
//    );
//  }
//}
