import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'action_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Auth _auth = Auth();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _auth.getCurrentUser().then((user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActionsPage(),
          ),
        );
      }
    });
  }

  void onGoogleSignIn(BuildContext context) async {
    setState(() {
      this.isLoading = true;
    });
    final user = await _auth.signInWithGoogle();
    print("I4M HEEEEEEERE");
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActionsPage(),
        ),
      );
    }
    setState(() {
      this.isLoading = false;
    });
  }

  void onAnonymousSignIn(BuildContext context) async {
    setState(() {
      this.isLoading = true;
    });
    await _auth.signInAnonymously();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionsPage(),
      ),
    );
    setState(() {
      this.isLoading = false;
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.all(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "We use signin tu save your favorites, nothing else",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  GoogleSignInButton(
                    onPressed: () {
                      onGoogleSignIn(context);
                    },
                  ),
                  AppleSignInButton(
                    onPressed: () {
                      //onGoogleSignIn(context);
                    },
                  ),
                  FacebookSignInButton(
                    onPressed: () {
                      //onGoogleSignIn(context);
                    },
                  ),
                  RaisedButton(
                    onPressed: () {
                      onAnonymousSignIn(context);
                    },
                    color: Colors.white,
                    child: Row(
                      children: [Text("Signin Anonymously")],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

class SettingsUserPage extends StatefulWidget {
  SettingsUserPage({Key key}) : super(key: key);

  @override
  _SettingsUserPageState createState() => _SettingsUserPageState();
}

class _SettingsUserPageState extends State<SettingsUserPage> {
  final Auth _auth = Auth();
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    _auth.getCurrentUser().then((user) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
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
                        Navigator.pop(context, false);
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
