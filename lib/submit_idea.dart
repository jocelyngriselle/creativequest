import 'package:flutter/material.dart';
import 'utils.dart';
import 'models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitIdeaPage extends StatefulWidget {
  final IdeaType ideatype;

  SubmitIdeaPage({Key key, this.ideatype}) : super(key: key);

  @override
  _SubmitIdeaPageState createState() => _SubmitIdeaPageState();
}

class _SubmitIdeaPageState extends State<SubmitIdeaPage> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final textFocusNode = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height -
        76; // 56 = size of the appbar TODO make this dynamic
    print(maxHeight);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // here the desired height
        child: AppBar(
          title: Text("SUBMIT AN IDEA",
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
                      height: maxHeight * 6 / 24,
                    ),
                    Container(
                      height: maxHeight * 13 / 24,
                      child: Container(
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
                        child: TextFormField(
                          focusNode: textFocusNode,
                          controller: textController,
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          cursorColor: Colors.white,
                          style: Theme.of(context).textTheme.bodyText1,
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
                                  //add to DB
                                  createRecord(textController.text);
                                  addToFavorites(_prefs, textController.text);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added to your favorites'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          ]),
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

  void createRecord(String text) async {
    final databaseReference = Firestore.instance;
    DocumentReference ref =
        await databaseReference.collection("fl_content").add({
      '_fl_meta_': {
        'schema': 'ideaSubmit',
        'schemaType': 'collection',
        'locale': 'en-US',
        'env': 'production',
        'schemaRef':
            "/fl_schemas/gxcJ5IHWnk1zAYpEISxL", // TODO make this dynmaic
      },
      'name': text,
      'type': "/fl_content/${this.widget.ideatype.reference}",
    });
    print(ref.documentID);
  }
}
