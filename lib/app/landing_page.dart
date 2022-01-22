import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tasks_time_tracker/app/home_page.dart';
import 'package:tasks_time_tracker/app/sign_in/sign_in.dart';
import 'package:tasks_time_tracker/services/auth.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _updateUser(widget.auth.currentUser);
  }

  void _updateUser(User? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        onSignIn: (user) => _updateUser(user),
        authBase: widget.auth,
      );
    } else {
      return HomePage(
        onSignOut: () => setState(() {
          _updateUser(null);
        }),
        authBase: widget.auth,
      );
    }
  }
}