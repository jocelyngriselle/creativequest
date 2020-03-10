import 'package:flutter/material.dart';
import 'models.dart';
import 'idea_page.dart';

class IdeaTypesPage extends StatefulWidget {
  final List<IdeaType> ideaTypes;

  IdeaTypesPage({Key key, this.ideaTypes}) : super(key: key);

  @override
  _IdeaTypesPageState createState() {
    return _IdeaTypesPageState();
  }
}

class _IdeaTypesPageState extends State<IdeaTypesPage> {
  @override
  Widget build(BuildContext context) {
    print("IdeaTypesPage");
    print(widget.ideaTypes);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "I'm shopping ideas to ...".toUpperCase(),
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60),
            _buildList(context)
          ]),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      children: widget.ideaTypes
          .map((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, IdeaType ideatype) {
    return Padding(
      key: ValueKey(ideatype.name),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: new ButtonTheme(
        minWidth: 300.0,
        height: 50.0,
        child: FlatButton(
            textColor: Colors.white,
            color: Theme.of(context).accentColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(ideatype.name.toUpperCase(),
                      style: TextStyle(fontSize: 20)),
                  SizedBox(
                    child: Image.asset('assets/images/mixer.jpg'),
                    height: 60,
                  ),
                ]),
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
