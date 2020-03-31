import 'package:creativequest/submit_idea.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import 'models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class IdeaPage extends StatefulWidget {
  final IdeaType ideatype;

  IdeaPage({Key key, this.ideatype}) : super(key: key);

  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage>
    with SingleTickerProviderStateMixin {
  Idea idea;
  Idea nextIdea;
  int index = -1;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Animation<double> rotateAnimation;
  Animation<Offset> slideAnimation;
  AnimationController controller;

  @override
  initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        getIdea();
        controller.reset();
      }
    });

    rotateAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(2, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));

    print("getIdea");
    print(this.index);
    index = (this.index + 1) % widget.ideatype.ideas.length;
    idea = widget.ideatype.ideas[index];
    nextIdea = widget.ideatype.ideas[index + 1];
  }

  dispose() {
    controller.dispose();
    super.dispose();
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
            Column(
              children: <Widget>[
                Container(
                  height: maxHeight * 6 / 24,
                ),
                Container(
                  height: maxHeight * 13 / 24,
                  child: _ideaCard(context, nextIdea),
                  //top: maxHeight / 3 - maxHeight / 9,
                ),
              ],
            ),
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
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget child) {
                      return Center(
                        child: Opacity(
                          opacity: 1 - controller.value,
                          child: idea.image,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  height: maxHeight * 9 / 24,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget child) {
                      return Center(
                        child: Transform.rotate(
                          angle: -pi / 12,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.green
                                  .withOpacity(min(controller.value * 4, 1)),
                              borderRadius: new BorderRadius.all(
                                const Radius.circular(16.0),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                "LIKE",
                                style: TextStyle(
                                  fontSize: 48.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Grotesk',
                                  color: Colors.white.withOpacity(
                                      min(controller.value * 6, 1)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
                          controller.forward();
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
                          controller.forward();
                          addToFavorites(_prefs, idea.description);
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

  void getIdea() {
    print("getIdea");
    print(this.index);
    var newIndex = (this.index + 1) % widget.ideatype.ideas.length;
    var newIdea = widget.ideatype.ideas[newIndex];
    var nextIdea =
        widget.ideatype.ideas[(newIndex + 1) % widget.ideatype.ideas.length];
    print(newIdea);
    print(nextIdea);

    setState(() {
      this.idea = newIdea;
      this.nextIdea = nextIdea;
      this.index = newIndex;
    });
  }

  Widget _ideaCard(BuildContext context, Idea idea) {
    if (idea == null) return CircularProgressIndicator();
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height - 76;
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).accentColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1.0, //extend the shadow
          )
        ],
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

  Widget _ideaBuilder(BuildContext context) {
    if (idea == null) return CircularProgressIndicator();

    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height - 76;
    double _localDX = 0.0;
    double _delta = 0.0;

    void _onStart(start) {
      _localDX = start.localPosition.dx;
    }

    void _onUpdate(update) {
      _delta = update.localPosition.dx - _localDX;
      controller.value = _delta / (maxWidth);
    }

    void _onEnd(end) {
      _delta > maxWidth / 3 ? controller.forward() : controller.reverse();
    }

    return GestureDetector(
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return SlideTransition(
            position: slideAnimation,
            child: Transform.rotate(
                angle: rotateAnimation.value * 0.3 * pi,
                child: _ideaCard(context, idea)),
          );
        },
      ),
    );
  }
}
