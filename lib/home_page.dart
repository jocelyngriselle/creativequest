import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'idea_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(197, 181, 130, 1),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/piano.png'),
            new Text(
              "I'm shopping ideas for ...".toUpperCase(),
              style: Theme.of(context).textTheme.display1,
            ),
            _buildBody(context)
          ]),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('ideatypes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final ideatype = IdeaType.fromSnapshot(data);

    return Padding(
      key: ValueKey(ideatype.name),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: new ButtonTheme(
        minWidth: 300.0,
        height: 50.0,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(100.0),
                side: BorderSide(color: Colors.red)),
            textColor: Colors.white,
            color: Color(0xFFBB4602),
            child: Text(ideatype.name.toUpperCase(),
                style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IdeaPage(ideatype: ideatype)),
              );
            }),
      ),
    );
  }
}
