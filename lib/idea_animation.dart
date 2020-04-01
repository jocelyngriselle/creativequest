import 'package:flutter/material.dart';
import 'models.dart';
import 'dart:math';

class IdeaAnimation extends StatefulWidget {
  final Idea idea;
  final void Function() onGestureEnd;

  IdeaAnimation({Key key, this.idea, this.onGestureEnd}) : super(key: key);

  @override
  IdeaAnimationState createState() => IdeaAnimationState();
}

class IdeaAnimationState extends State<IdeaAnimation>
    with SingleTickerProviderStateMixin {
  bool _gestureStatus = true; // are we adding to favorite or passing ?
  Animation<double> rotateAnimation;
  Animation<Offset> slideAnimation;
  Animation<Offset> slideAnimationNok;
  Animation<double> opacityAnimation;
  Animation<double> backgroundOpacityAnimation;
  AnimationController controller;

  @override
  initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 750),
        reverseDuration: const Duration(milliseconds: 500),
        vsync: this);
    controller.addStatusListener((status) {
      //if (status == AnimationStatus.completed) {
      //getIdea();
      //controller.reset();
      //}
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

    backgroundOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    opacityAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOutExpo)),
          weight: 60.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
      ],

      //Tween<double>(
      //begin: 0.0,
      //end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));

    slideAnimationNok = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-2, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    ));
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  like() {
    widget.onGestureEnd();
    _gestureStatus = true;
    controller.forward();
  }

  pass() {
    widget.onGestureEnd();
    _gestureStatus = false;
    controller.forward();
  }

  reverse() {
    //_gestureStatus = false;
    controller.reverse();
  }

  reset() {
    //_gestureStatus = false;
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height -
        76; // 56 = size of the appbar TODO make this dynamic

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return Opacity(
                  opacity: backgroundOpacityAnimation.value,
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    height: maxHeight * 6 / 24,
                  ),
                );
              },
            ),
            Container(
              //color: Colors.yellow,
              height: maxHeight * 13 / 24,
              child: _ideaBuilder(context),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              //color: Colors.pink,
              height: maxHeight * 9 / 24,
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  var opacity = (1 - controller.value);
                  return Opacity(
                    opacity: opacity,
                    child: Center(
                      child: widget.idea.image,
                    ), // TODO change
                  );
//                  return Center(
//                    child: Opacity(
//                      opacity: opacity,
//                      child: widget.idea.image, // TODO change
//                    ),
                  //);
                },
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              height: maxHeight * 9 / 24,
              //color: Colors.deepPurple,
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget child) {
                  var opacity = opacityAnimation
                      .value; //min(opacityAnimation.value * 12, 1);
                  //opacity = opacity > 0.7 ? 0.0 : opacity;
                  print("OPACITY");
                  print(opacityAnimation.value);
                  print(opacity);
                  var text = _gestureStatus ? 'LIKE' : 'PASS';
                  var color = _gestureStatus
                      ? Colors.green.withOpacity(opacity)
                      : Colors.red.withOpacity(opacity);
                  return Center(
                    child: Transform.rotate(
                      angle: -pi / 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: new BorderRadius.all(
                            const Radius.circular(16.0),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 48.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Grotesk',
                              color: Colors.white.withOpacity(opacity),
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
      ],
    );
  }

  Widget _ideaCard(
    BuildContext context,
  ) {
    if (widget.idea == null) return CircularProgressIndicator();
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
          widget.idea.description,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget _ideaBuilder(BuildContext context) {
    if (widget.idea == null) return CircularProgressIndicator();

    final maxWidth = MediaQuery.of(context).size.width;
    double _localDX = 0.0;
    double _delta = 0.0;

    void _onStart(start) {
      _localDX = start.localPosition.dx;
    }

    void _onUpdate(update) {
      _delta = update.localPosition.dx - _localDX;
      _gestureStatus = _delta >= 0;
      controller.value = _delta.abs() / (maxWidth);
    }

    void _onEnd(end) {
      _delta.abs() > maxWidth / 3
          ? _gestureStatus ? like() : pass()
          : controller.reverse();
    }

    return GestureDetector(
      onHorizontalDragStart: _onStart,
      onHorizontalDragUpdate: _onUpdate,
      onHorizontalDragEnd: _onEnd,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return SlideTransition(
            position: _gestureStatus ? slideAnimation : slideAnimationNok,
            child: Transform.rotate(
                angle: _gestureStatus
                    ? rotateAnimation.value * 0.2 * pi
                    : -rotateAnimation.value * 0.2 * pi,
                child: _ideaCard(context)),
          );
        },
      ),
    );
  }
}
