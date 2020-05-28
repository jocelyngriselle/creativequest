import 'package:creativequest/idea_submit.dart';
import 'package:creativequest/routes.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'action.dart';
import 'idea.dart';
import 'idea_animation.dart';

class IdeaPage extends StatefulWidget {
  final CreativeAction action;

  IdeaPage({Key key, this.action}) : super(key: key);

  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  List<Idea> ideas = [];
  List<GlobalKey<IdeaAnimationState>> _keys = [];
  int currentIndex;
  final IdeaRepository repository = IdeaRepository();

  initIdeas() {
    repository.getIdeas(widget.action).then((snapshot) {
      setState(() {
        this.ideas = snapshot;
        this.currentIndex = ideas.length - 1;
      });
      for (var i = 0; i < ideas.length; i++) {
        _keys.add(GlobalKey());
      }
    });
  }

  @override
  initState() {
    super.initState();
    initIdeas();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // here the desired height
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).accentColor,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Center(
                  child: Text(widget.action.name.toUpperCase(),
                      style: Theme.of(context).textTheme.headline5),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              )
            ],
          ),
          elevation: 0.0,
        ),
      ),
      body: SafeArea(
        //top: false,
        //bottom: false,
        child: Container(
          height: double.infinity,
          //color: Colors.pink,
          child: Stack(
            alignment: Alignment.topCenter,
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
                height: maxHeight * 20 / 24,
                child: _ideaList(context),
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: maxHeight * 17.5 / 24 - 6,
                  ),
                  Container(
                    height: maxHeight * 3 / 24,
                    width: maxWidth * 0.7,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                              color: Theme.of(context).primaryColor,
                            ),
                            backgroundColor: Theme.of(context).backgroundColor,
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
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        FloatingActionButton(
                          heroTag: "Favorite",
                          onPressed: () {
                            _keys[currentIndex].currentState.like();
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        FloatingActionButton(
                          heroTag: "Add",
                          mini: true,
                          onPressed: () {
                            Navigator.pushNamed(context, submitRoute,
                                arguments: widget.action);
                          },
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).primaryColor,
                          ),
                          backgroundColor: Theme.of(context).backgroundColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void next() {
    setState(() {
      currentIndex--;
    });
  }

  void back() {
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
    if (ideas.length > 0) {
      return Stack(
        children: List.generate(
          ideas.length,
          (index) {
            return IdeaAnimation(
              key: _keys[index],
              idea: ideas[index],
              onGestureEnd: () {
                next();
              },
            );
          },
        ),
      );
    } else {
      return SizedBox(
        height: min((MediaQuery.of(context).size.height) / 2,
            MediaQuery.of(context).size.width * 0.9),
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
          ),
        ),
      );
    }
  }
}
