import 'package:creativequest/submit_idea.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'idea_animation.dart';

class IdeaPage extends StatefulWidget {
  final IdeaType ideatype;

  IdeaPage({Key key, this.ideatype}) : super(key: key);

  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  //Idea idea;
  //Idea nextIdea;
  List<Idea> ideas = [];
  //int index = -1;
  List<GlobalKey<IdeaAnimationState>> _keys = [];
  int currentIndex;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  initState() {
    super.initState();
    print("initState");
    ideas = widget.ideatype.ideas;
    for (var i = 0; i < ideas.length; i++) {
      _keys.add(GlobalKey());
    }
    currentIndex = ideas.length - 1;
    //nextIdea = widget.ideatype.ideas[index + 1];
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
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: Center(
                child: FloatingActionButton(
                  heroTag: "Replay",
                  mini: false,
                  onPressed: () {
                    resetAll();
                  },
                  child: Icon(
                    Icons.cached,
                    color: Theme.of(context).accentColor,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            Container(
              height: maxHeight * 19 / 24,
              child: _ideaList(context),
              //top: maxHeight / 3 - maxHeight / 9,
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
                      AnimatedOpacity(
                        opacity: currentIndex == ideas.length - 1 ? 0 : 1,
                        duration: Duration(
                            milliseconds:
                                200), //TODO this doent work index BUGGEd
                        child: FloatingActionButton(
                          heroTag: "Update",
                          mini: true,
                          onPressed: () {
                            resetLast();
                          },
                          child: Icon(
                            Icons.replay,
                            color: Theme.of(context).accentColor,
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: "Delete",
                        onPressed: () {
                          _keys[currentIndex].currentState.pass();
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
                          _keys[currentIndex].currentState.like();
                          //controller.forward();
                          //addToFavorites(_prefs, ideas.last.description);
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
          ],
        ),
      ),
    );
  }

  void next() {
    print("FUNCTION NEXT");
    setState(() {
      currentIndex--;
    });
  }

  void back() {
    print("FUNCTION LAST");
    setState(() {
      currentIndex++;
    });
  }

  void resetLast() {
    print(currentIndex);
    print(ideas.length);
    if (currentIndex < ideas.length - 1) {
      _keys[currentIndex + 1].currentState.reverse();
      back();
    }
  }

  void resetAll() {
    for (var i = 0; i < ideas.length; i++) {
      _keys[i].currentState.reset();
    }

    setState(() {
      currentIndex = ideas.length - 1;
    });
  }

  Widget _ideaList(BuildContext context) {
    return Stack(
      children: List.generate(
        ideas.length,
        (index) {
          return Column(
            children: <Widget>[
              IdeaAnimation(
                key: _keys[index],
                idea: ideas[index],
                onGestureEnd: () {
                  next();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
