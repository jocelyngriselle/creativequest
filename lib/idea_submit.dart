import 'package:flutter/material.dart';
import 'action.dart';
import 'idea.dart';
import 'favorite.dart';

import 'package:keyboard_visibility/keyboard_visibility.dart';

class SubmitIdeaPage extends StatefulWidget {
  final CreativeAction action;

  SubmitIdeaPage({Key key, this.action}) : super(key: key);

  @override
  _SubmitIdeaPageState createState() => _SubmitIdeaPageState();
}

class _SubmitIdeaPageState extends State<SubmitIdeaPage> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final textFocusNode = FocusNode();
  IdeaRepository _ideaRepository = IdeaRepository();
  FavoriteRepository _favoriteRepository = FavoriteRepository();
  double maxHeight;
  bool showImage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        // Add state updating code
        setState(() {
          showImage = visible ? false : true;
        });
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void onSubmit() async {
    final idea =
        await _ideaRepository.createRecord(textController.text, widget.action);
    _favoriteRepository.addFavorite(textController.text, idea);
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    maxHeight = showImage
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height / 2;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // here the desired height
        child: AppBar(
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          elevation: 0.0,
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
              ]),
        ),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height:
                          showImage ? maxHeight * 6 / 24 : maxHeight * 1 / 24,
                    ),
                    Container(
                      height:
                          showImage ? maxHeight * 13 / 24 : maxHeight * 18 / 24,
                      child: Container(
                        decoration: new BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: new BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        width: maxWidth * 0.8,
                        padding: EdgeInsets.fromLTRB(
                          maxHeight * 1 / 24,
                          maxHeight * 1 / 24,
                          maxHeight * 1 / 24,
                          maxHeight * 1 / 24,
                        ),
                        child: SingleChildScrollView(
                          child: TextFormField(
                            focusNode: textFocusNode,
                            controller: textController,
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            cursorColor: Colors.white,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).cardColor),
                            decoration: InputDecoration(
                              labelText: '',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please enter some text'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return '';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                showImage
                    ? Column(
                        children: <Widget>[
                          Container(
                            height: maxHeight * 7 / 24,
                            child: Center(
                                child: Image.asset(
                              "assets/images/speakers.png",
                              fit: BoxFit.fitHeight,
                            )),
                          ),
                        ],
                      )
                    : Container(),
                Column(
                  children: <Widget>[
                    Container(
                      height:
                          showImage ? maxHeight * 18 / 24 : maxHeight * 17 / 24,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: "Edit",
                            onPressed: () {
                              textFocusNode.requestFocus();
                            },
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).accentColor,
                            ),
                            backgroundColor: Colors.white,
                          ),
                          FloatingActionButton(
                            heroTag: "Submit",
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                onSubmit();
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added to your favorites'),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              Icons.check,
                              color: Theme.of(context).cardColor,
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
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
      ),
    );
  }
}
