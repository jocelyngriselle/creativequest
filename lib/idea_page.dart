import 'package:flutter/material.dart';
import 'models.dart';

class IdeaPage extends StatefulWidget {
  final IdeaType ideatype;

  IdeaPage({Key key, this.ideatype}) : super(key: key);

  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  Idea idea;
  int index = -1;

  @override
  initState() {
    super.initState();
    getIdea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
            SizedBox(
              height: 200,
              child: Image.asset('assets/images/mpc.png'),
            ),
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

  void getIdea() {
    print("getIdea");
    print(this.index);
    var newIndex = (this.index + 1) % widget.ideatype.ideas.length;
    print(newIndex);
    print(widget.ideatype.ideas.length);
    var newIdea = widget.ideatype.ideas[newIndex];

    setState(() {
      this.idea = newIdea;
      this.index = newIndex;
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
              style: Theme.of(context).textTheme.display2,
            ),
          ),
        ]);
  }
}
