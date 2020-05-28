import 'package:creativequest/favorites_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'action.dart';
import 'idea_page.dart';
import 'idea_submit.dart';
import 'routes.dart';

class ActionsPage extends StatefulWidget {
  @override
  _ActionsPageState createState() {
    return _ActionsPageState();
  }
}

class _ActionsPageState extends State<ActionsPage> {
  final ActionRepository repository = ActionRepository();
  List<CreativeAction> actions = [];

  @override
  void initState() {
    super.initState();
    repository.getActions().then((actions) {
      print(actions);
      setState(() {
        this.actions = actions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // here the desired height
        child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0.0,
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "I'm ",
                style: Theme.of(context).textTheme.headline1,
                children: <TextSpan>[
                  TextSpan(
                      text: "shopping",
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(color: Theme.of(context).accentColor)),
                  TextSpan(
                      text: " for ideas to",
                      style: Theme.of(context).textTheme.headline1),
                ],
              ),
            ),
            leading: IconButton(
              iconSize: 30.0,
              icon: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  accountRoute,
                );
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Theme.of(context).accentColor,
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
            ]),
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Center(child: _buildList(context)),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    print(actions.length);
    if (actions.length != 0) {
      return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children:
              actions.map((data) => _buildListItem(context, data)).toList());
    } else {
      return SizedBox(
        height: min((MediaQuery.of(context).size.height) / 2,
            MediaQuery.of(context).size.width * 0.9),
        child: Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
        ),
      );
    }
  }

  Widget _buildListItem(BuildContext context, CreativeAction action,
      [int index]) {
    final margin = 16.0;
    final maxHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
//          color: index % 2 == 0
////              ? Theme.of(context).accentColor
////              : Theme.of(context).primaryColor,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      key: ValueKey(action.name),
      margin: EdgeInsets.fromLTRB(margin, 0, margin, margin),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: maxHeight / 4,
            child: Opacity(
              opacity: 0.1,
              child: action.image,
            ),
          ),
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width - margin,
            height: maxHeight / 4,
            buttonColor: Colors.green,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  action.name.toUpperCase(),
                  style: Theme.of(context).textTheme.headline4.copyWith(
//                            color: index % 2 == 0
//                                ? Theme.of(context).primaryColor
//                                : Colors.white
                      color: Theme.of(context).cardColor),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: action.name.toLowerCase() == "submit an idea"
                        ? (context) => SubmitIdeaPage(action: action)
                        : (context) => IdeaPage(action: action),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
