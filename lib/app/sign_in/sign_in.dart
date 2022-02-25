import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:tasks_time_tracker/app/sign_in/sign_in_button.dart';
import 'package:tasks_time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:provider/provider.dart';
import 'package:tasks_time_tracker/services/auth.dart';
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);


  Future<void> _signInAnonymously(BuildContext context) async {

    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      await auth.signInWithFaceBook();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context){
   Navigator.of(context).push(
     MaterialPageRoute<void>(
       fullscreenDialog:true,
       builder: (context)=> const EmailSignInPage()
     )
   );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Time Tracker')),
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 48),
          SocialSignInButton(
            picLogo: 'assets/images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed:()=> _signInWithGoogle(context),
          ),
          const SizedBox(height: 8),
          SocialSignInButton(
            picLogo: 'assets/images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: const Color(0xFF334D92),
            onPressed:()=> _signInWithFacebook(context),
          ),
          const SizedBox(height: 8),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: ()=>_signInWithEmail(context),
          ),
          const SizedBox(height: 8),
          const Text(
            'or',
            style: TextStyle(color: Colors.black87, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime,
            onPressed:()=> _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
}