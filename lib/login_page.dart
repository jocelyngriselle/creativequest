import 'package:creativequest/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'auth.dart';
import 'package:flutter/scheduler.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Auth _auth = Auth();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("IN LOGIN PAGE");
    /*_auth.getCurrentUser().then((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, actionRoute);
      }
    });*/
  }

  void onGoogleSignIn(BuildContext context) async {
    setState(() {
      this.isLoading = true;
    });
    final user = await _auth.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacementNamed(context, actionRoute);
    }
    setState(() {
      this.isLoading = false;
    });
  }

  void onAnonymousSignIn(BuildContext context) async {
    print("onAnonymousSignIn");
    setState(() {
      this.isLoading = true;
    });
    final user = await _auth.signInAnonymously();
    if (user != null) {
      Navigator.pushReplacementNamed(context, actionRoute);
    }
    setState(() {
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 4,
              child: Center(
                child:
                    Text("LOGIN", style: Theme.of(context).textTheme.headline5),
              ),
            ),
            Flexible(
              child: Container(),
              flex: 1,
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: _auth.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, actionRoute);
            });
            return Center(child: CircularProgressIndicator());
          } else {
            return isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    padding: EdgeInsets.all(50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "We use signin to save your favorites, nothing else",
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
                  );
          }
        },
      ),
    );
  }
}
