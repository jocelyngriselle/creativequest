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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                            'assets/images/tape-recorder-decorated.png'),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                                children: [
                                  Text(
                                    "Signin Anonymously",
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }
}
