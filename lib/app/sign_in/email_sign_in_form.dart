import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_time_tracker/services/auth.dart';
import 'package:tasks_time_tracker/widgets/form_submit_button.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key, required this.authBase}) : super(key: key);
  final AuthBase authBase;

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _submit() async {
    try {
      _formType == EmailSignInFormType.signIn
          ? await widget.authBase.signInWithEmailAndPassword(_email, _password)
          : await widget.authBase
              .createUserWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      FocusScope.of(context).requestFocus(_emailFocusNode);
    });
  }

  void _onEmailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _onPasswordEditingComplete() {
    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
  }

  List<Widget> _buildChidren() {
    final _submitButtonText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final _linkButtonText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'You have an account? Sign in';
    return [
      _buildEmailTextField(),
      const SizedBox(
        height: 8,
      ),
      _buildPasswordTextField(),
      _buildConfirmPasswordTextFeild(),
      const SizedBox(
        height: 8,
      ),
      FormSubmitButton(
        text: _submitButtonText,
        onPressed: _submit,
      ),
      const SizedBox(
        height: 8,
      ),
      FlatButton(
        onPressed: _toggleFormType,
        child: Text(_linkButtonText),
      )
    ];
  }

  Opacity _buildConfirmPasswordTextFeild() {
    return Opacity(
      opacity: _formType == EmailSignInFormType.signIn ? 0 : 1,
      child: TextField(
        controller: _confirmPasswordController,
        decoration: const InputDecoration(
          labelText: 'Confirm Password',
        ),
        obscureText: true,
        focusNode: _confirmPasswordFocusNode,
        onEditingComplete: _submit,
      ),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'user@test.com',
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _onEmailEditingComplete,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onEditingComplete: _formType == EmailSignInFormType.signIn
          ? _submit
          : _onPasswordEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChidren(),
      ),
    );
  }
}