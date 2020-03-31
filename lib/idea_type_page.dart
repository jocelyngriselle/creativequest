import 'dart:math';

import 'package:creativequest/favorite_page.dart';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // here the desired height
        child: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesPage(),
                  ),
                );
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: min((MediaQuery.of(context).size.height) / 2,
                    MediaQuery.of(context).size.width * 0.9),
                height: min((MediaQuery.of(context).size.height) / 2,
                    MediaQuery.of(context).size.width * 0.9),
                child: Container(
                  decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(200.0),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/moog.png',
                      height: 300,
                      width: 300,
                    ),
                  ),
                ),
              ),
              Text(
                "I'm shopping ideas to :",
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              _buildList(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: widget.ideaTypes
          .map((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, IdeaType ideatype) {
    return Container(
      key: ValueKey(ideatype.name),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: new ButtonTheme(
        height: 50.0,
        child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(50.0),
            ),
            textColor: Colors.white,
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    ideatype.name.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
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
