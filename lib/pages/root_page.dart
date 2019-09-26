import 'package:flutter/material.dart';
import 'package:asset_tracker_mobile/services/authentication.dart';
import 'package:asset_tracker_mobile/pages/login_signup_page.dart';
import 'package:asset_tracker_mobile/pages/home_page.dart';

class RootPage extends StatefulWidget {
  final BaseAuth auth;

  RootPage({this.auth});

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "admin";

  @override
  Widget build(BuildContext context) {
    switch(authStatus) {
      case AuthStatus.NOT_LOGGED_IN:
      case AuthStatus.NOT_DETERMINED:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
      case AuthStatus.LOGGED_IN:
        return new HomePage(
          userId: _userId,
          auth: widget.auth,
          onSignedOut: _onSignedOut,
        );
    }
  }

  @override
  void initState() {
    super.initState();
    var user = widget.auth.getCurrentUser();
    setState(() {
      assignUserId(User(name: user, mail: user, password: ""));
      setAuthStatus(User(name: user, mail: user, password: ""));
    });
  }

  void _onLoggedIn() {
    var user = widget.auth.getCurrentUser();
    setState(() {
      _userId = user;
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut() {
    print("signing out");
  }

  void assignUserId(User user) {
    if (user != null) {
      _userId = user?.name;
    }
  }

  void setAuthStatus(User user) {
    authStatus =
        user?.name == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
  }
}

enum AuthStatus { NOT_DETERMINED, NOT_LOGGED_IN, LOGGED_IN }
