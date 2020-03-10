import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'idea_type_page.dart';
import 'models.dart';

class HomePage extends StatelessWidget {
  Future<QuerySnapshot> getData() {
    return Future<QuerySnapshot>.delayed(
      Duration(seconds: 2),
      () => Firestore.instance.collection('fl_content').getDocuments(),
    );
  }

  List<IdeaType> getIdeaTypes(List<DocumentSnapshot> data) {
    print("here");
    print(data);
    List<DocumentSnapshot> ideaTypesSnapshots =
        data.where((i) => i.data["_fl_meta_"]["schema"] == "ideatype").toList();
    print("ici");
    print(ideaTypesSnapshots);
    List<IdeaType> ideaTypes1 = [];

    for (var ideaTypeSnapshot in ideaTypesSnapshots) {
      print("here57");
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
    /*List<IdeaType> ideaTypes = ideaTypesSnapshots
        .map((ideatype) => IdeaType.fromSnapshot(ideatype))
        .toList();
    print(ideaTypes);
    print(data[0].data);
    print(data[0].data["_fl_meta_"]["schema"]);*/
    //return data;
    //setState(() => this.idea = Idea.fromSnapshot(
    // data.documents[rng.nextInt(data.documents.length)],));
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
          Text(
            "Creative Quest".toUpperCase(),
            style: Theme.of(context).textTheme.display1,
          ),
          Text(
            "Music Production Coach",
            style: Theme.of(context).textTheme.display2,
          ),
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
                          height: 200,
                          child: Image.asset('assets/images/piano.jpg')),
                      /*Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 60,
                          )*/
                    )
                  ];
                } else {
                  children = <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Loading...'),
                    ),
                    SizedBox(
                      height: 200,
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
              })
        ]),
      ),
    );
  }
}
