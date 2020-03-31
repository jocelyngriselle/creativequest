import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'idea_type_page.dart';
import 'models.dart';
import 'dart:math';

class HomePage extends StatelessWidget {
  Future<QuerySnapshot> getData() {
    return Future<QuerySnapshot>.delayed(
      Duration(seconds: 2),
      () => Firestore.instance.collection('fl_content').getDocuments(),
    );
  }

  List<IdeaType> getIdeaTypes(List<DocumentSnapshot> data) {
    List<DocumentSnapshot> ideaTypesSnapshots =
        data.where((i) => i.data["_fl_meta_"]["schema"] == "ideatype").toList();
    print(ideaTypesSnapshots);
    List<IdeaType> ideaTypes1 = [];

    for (var ideaTypeSnapshot in ideaTypesSnapshots) {
      print(data[0].data);
      print(data[0].metadata);
      //print(data[2].data["field_1576669262429"].documentID);
      print(ideaTypeSnapshot.documentID);
      List<DocumentSnapshot> ideasSnapshots = data
          .where((i) =>
              i.data["_fl_meta_"]["schema"] == "idea" &&
              i.data["type"].documentID == ideaTypeSnapshot.documentID)
          .toList();

      var ideaType = IdeaType.fromSnapshot(ideaTypeSnapshot, ideasSnapshots);
      ideaTypes1.add(ideaType);
    }
    return ideaTypes1;
  }

  @override
  Widget build(BuildContext context) {
    var data = getData();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          SizedBox(
            height: 30,
          ),
          FutureBuilder<QuerySnapshot>(
              future: data,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                List<Widget> children;
                print("snapshot");
                print(snapshot);
                if (snapshot.hasData) {
                  print("hasdata");
                  print(snapshot.data.documents[0].data["_fl_meta_"]["schema"]);
                  children = <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IdeaTypesPage(
                                  ideaTypes:
                                      getIdeaTypes(snapshot.data.documents))),
                        );
                      },
                      child: SizedBox(
                          height: min((MediaQuery.of(context).size.height) / 2,
                              MediaQuery.of(context).size.width * 0.9),
                          width: min((MediaQuery.of(context).size.height) / 2,
                              MediaQuery.of(context).size.width * 0.9),
                          child:
                              Image.asset('assets/images/tape-recorder.png')),
                      /*Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 60,
                          )*/
                    )
                  ];
                } else {
                  children = <Widget>[
                    SizedBox(
                      height: min((MediaQuery.of(context).size.height) / 2,
                          MediaQuery.of(context).size.width * 0.9),
                      child: Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              }),
          Text(
            "Creative".toUpperCase(),
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(
            "Hacks".toUpperCase(),
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            "Music Production Coach",
            style: Theme.of(context).textTheme.headline1,
          ),
        ]),
      ),
    );
  }
}
