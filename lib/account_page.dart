import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'routes.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final Auth _auth = Auth();
  User _user;

  @override
  void initState() {
    super.initState();
    _auth.getCurrentUser().then((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, loginRoute);
      } else {
        setState(() {
          this._user = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                    const Radius.circular(10.0),
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
                child: Text("ACCOUNT",
                    style: Theme.of(context).textTheme.headline5),
              ),
            ),
            Flexible(
              child: Container(),
              flex: 1,
            )
          ],
        ),
      ),
      body: _user != null
          ? Container(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.all(50),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _user.isAnonymous
                        ? Container()
                        : ClipOval(
                            child: Image.network(_user.photoUrl,
                                width: 100, height: 100, fit: BoxFit.cover)),
                    SizedBox(height: 20),
                    Text('Welcome,',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1),
                    _user.isAnonymous
                        ? Text("Creative user",
                            style: Theme.of(context).textTheme.bodyText1)
                        : Text(_user.displayName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(height: 20),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        _auth.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (Route<dynamic> route) => false);
                        // TODO pop up to ensure anonymous user don't delete all their data
                      },
                      color: Colors.redAccent,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.exit_to_app, color: Colors.white),
                            SizedBox(width: 10),
                            Text('Log out',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
