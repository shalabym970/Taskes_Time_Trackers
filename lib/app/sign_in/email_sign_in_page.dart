import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_time_tracker/services/auth.dart';

import 'email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key, required this.authBase}) : super(key: key);
  final AuthBase authBase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Sign In')),
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body:   Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: EmailSignInForm(authBase: authBase ),
        ),
      ),
    );
  }
}