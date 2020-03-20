import 'package:creativequest/submit_idea.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdeaPage extends StatefulWidget {
  final IdeaType ideatype;

  IdeaPage({Key key, this.ideatype}) : super(key: key);

  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  Idea idea;
  int index = -1;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  initState() {
    super.initState();
    getIdea();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height -
        76; // 56 = size of the appbar TODO make this dynamic

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // here the desired height
        child: AppBar(
          title: Text(widget.ideatype.name.toUpperCase(),
              style: Theme.of(context).textTheme.headline5),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              Navigator.pop(context);
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
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: maxHeight * 6 / 24,
                ),
                Container(
                  height: maxHeight * 13 / 24,
                  child: _ideaBuilder(context),
                  //top: maxHeight / 3 - maxHeight / 9,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  height: maxHeight * 9 / 24,
                  child: Center(child: randomImg()),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  height: maxHeight * 18 / 24,
                ),
                Container(
                  width: maxWidth * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "Update",
                        mini: true,
                        onPressed: () {
                          getIdea();
                        },
                        child: Icon(
                          Icons.replay,
                          color: Theme.of(context).accentColor,
                        ),
                        backgroundColor: Colors.white,
                      ),
                      FloatingActionButton(
                        heroTag: "Delete",
                        onPressed: () {
                          getIdea();
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.red,
                      ),
                      FloatingActionButton(
                        heroTag: "Favorite",
                        onPressed: () {
                          addToFavorites(_prefs, idea.description);
                          getIdea();
                        },
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.green,
                      ),
                      FloatingActionButton(
                        heroTag: "Add",
                        mini: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SubmitIdeaPage(ideatype: widget.ideatype)),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).accentColor,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
//          Column(
//            children: <Widget>[
//              Container(
//                height: maxHeight * 17 / 24,
//              ),
//              Container(
//                height: maxHeight * 5 / 24,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    RaisedButton(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(50.0),
//                      ),
//                      onPressed: () {
//                        getIdea();
//                      },
//                      child: Text(
//                        'MORE IDEAS',
//                        style: Theme.of(context).textTheme.button,
//                      ),
//                      textColor: Colors.white,
//                      color: Theme.of(context).accentColor,
//                    ),
//                    FlatButton(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(50.0),
//                      ),
//                      onPressed: () {
//                        getIdea();
//                      },
//                      child: Text('SUBMIT AN IDEA',
//                          style: Theme.of(context).textTheme.button),
//                      textColor: Colors.white,
//                      color: Theme.of(context).cardColor,
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
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

    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height - 76;

    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: new BorderRadius.all(
          const Radius.circular(16.0),
        ),
      ),
      width: maxWidth * 0.8,
      padding: EdgeInsets.fromLTRB(
        maxHeight * 1 / 24,
        maxHeight * 1 / 24,
        maxHeight * 1 / 24,
        maxHeight * 1 / 24,
      ),
      child: Center(
        child: Text(
          idea.description,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
