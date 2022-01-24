import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_time_tracker/services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.authBase}) : super(key: key);
  final AuthBase authBase;

  Future<void> _signOut() async {
    try {
      await authBase.signOut();

    } catch (e) {
      print(e.toString());


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
        actions: [
          FlatButton(
            onPressed: _signOut,
            child: const Text(
              "Logout",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}