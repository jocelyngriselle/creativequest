import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'dart:math';

class IdeaPage extends StatefulWidget {
  final IdeaType ideatype;

  IdeaPage({Key key, this.ideatype}) : super(key: key);

  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  Idea idea;

  @override
  initState() {
    super.initState();
    getIdea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(197, 181, 130, 1),
      appBar: AppBar(
        title: Text(widget.ideatype.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/piano.png'),
            _ideaBuilder(context),
            RaisedButton(
              onPressed: () {
                getIdea();
              },
              child: Text('MORE IDEA', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Future getIdea() {
    final rng = new Random();
    Firestore.instance
        .collection('ideatypes')
        .document(widget.ideatype.reference.documentID)
        .collection('ideas')
        .snapshots()
        .listen((data) {
      setState(() => this.idea = Idea.fromSnapshot(
          data.documents[rng.nextInt(data.documents.length)]));
    });
  }

  Widget _ideaBuilder(BuildContext context) {
    if (idea == null) return CircularProgressIndicator();
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: new Text(
              idea.description.toUpperCase(),
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ]);
  }

  Widget _buildBody(BuildContext context) {
    final url = widget.ideatype.reference.path + '/ideas/';
    print('url:$url');
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(url)
          //.where("name", isEqualTo: widget.ideatype.name)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        print("lala");
        print(snapshot.data.documents.first.data);
        snapshot.data.documents.map((data) => print(data));
        print(Idea.fromSnapshot(snapshot.data.documents[2]));
        setState(
            () => this.idea = Idea.fromSnapshot(snapshot.data.documents.first));
        print('over');
        return _ideaBuilder(context);
      },
    );
  }
}
