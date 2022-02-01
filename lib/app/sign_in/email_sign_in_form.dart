import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_time_tracker/app/sign_in/validator.dart';
import 'package:tasks_time_tracker/services/auth.dart';
import 'package:tasks_time_tracker/widgets/form_submit_button.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidation {
  EmailSignInForm({Key? key, required this.authBase}) : super(key: key);
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

  String get _confirmationPassword => _confirmPasswordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _submit() async {
    try {
      _formType == EmailSignInFormType.signIn
          ? await widget.authBase.signInWithEmailAndPassword(_email, _password)
          : await widget.authBase
              .createUserWithEmailAndPassword(_email, _confirmationPassword);
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
    bool _sigInEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);
    bool _registerEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        widget.confirmationPasswordValidator.isValid(_confirmationPassword) &&
        _confirmationPassword == _password;
    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      _buildConfirmPasswordTextField(),
      const SizedBox(
        height: 8,
      ),
      FormSubmitButton(
        text: _submitButtonText,
        onPressed: _formType == EmailSignInFormType.signIn
            ? _sigInEnabled
                ? _submit
                : null
            : _registerEnabled
                ? _submit
                : null,
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

  Widget _buildConfirmPasswordTextField() {
    bool confirmationPasswordValid =
        widget.confirmationPasswordValidator.isValid(_confirmationPassword);
    return Opacity(
      opacity: _formType == EmailSignInFormType.signIn ? 0 : 1,
      child: TextField(
        controller: _confirmPasswordController,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          errorText:
              confirmationPasswordValid && _confirmationPassword == _password
                  ? null
                  : widget.invalidConfirmationPasswordErrorText,
        ),
        obscureText: true,
        onChanged: (email) => _updateSetState(),
        focusNode: _confirmPasswordFocusNode,
        onEditingComplete: _submit,
      ),
    );
  }

  Widget _buildEmailTextField() {
    bool emailValid = widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'user@test.com',
        errorText: emailValid ? null : widget.invalidEmailErrorText,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onChanged: (email) => _updateSetState(),
      onEditingComplete: _onEmailEditingComplete,
    );
  }

  Widget _buildPasswordTextField() {
    bool passwordValid = widget.passwordValidator.isValid(_password);

    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: passwordValid ? null : widget.invalidPasswordErrorText,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => _updateSetState(),
      onEditingComplete: _formType == EmailSignInFormType.signIn
          ? _submit
          : _onPasswordEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView(
        primary: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChidren(),
          ),
        ],
      ),
    );
  }

  _updateSetState() {
    setState(() {});
  }
}