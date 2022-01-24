import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_time_tracker/app/home_page.dart';
import 'package:tasks_time_tracker/app/sign_in/sign_in.dart';
import 'package:tasks_time_tracker/services/auth.dart';

class LandingPage extends StatelessWidget {
   const LandingPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage(
              authBase: auth,
            );
          } else {
            return HomePage(
              authBase: auth,
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}