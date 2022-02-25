import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_time_tracker/app/sign_in/validator.dart';
import 'package:tasks_time_tracker/services/auth.dart';
import 'package:tasks_time_tracker/widgets/form_submit_button.dart';
import 'package:tasks_time_tracker/widgets/show_exception_alert_dialog.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidation {
  EmailSignInForm({Key? key}) : super(key: key);

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
  bool _submitted = false;
  bool _isLoading = false;

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      _formType == EmailSignInFormType.signIn
          ? await auth.signInWithEmailAndPassword(_email, _password)
          : await auth.createUserWithEmailAndPassword(
              _email, _confirmationPassword);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    final newFocus = widget.passwordValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _onPasswordEditingComplete() {
    final newFocus = widget.passwordValidator.isValid(_password)
        ? _confirmPasswordFocusNode
        : _passwordFocusNode;

    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    final _submitButtonText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final _linkButtonText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'You have an account? Sign in';
    bool _sigInEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    bool _registerEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        widget.confirmationPasswordValidator.isValid(_confirmationPassword) &&
        _confirmationPassword == _password &&
        !_isLoading;
    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      _buildConfirmPasswordTextField(),
      const SizedBox(
        height: 8,
      ),
      FormSubmitButton(
        text: _submitButtonText,
        onPressed: () => _formType == EmailSignInFormType.signIn
            ? _sigInEnabled
                ? _submit()
                : null
            : _registerEnabled
                ? _submit()
                : null,
      ),
      const SizedBox(
        height: 8,
      ),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(_linkButtonText),
      )
    ];
  }

  Widget _buildConfirmPasswordTextField() {
    bool showErrorMessage = _submitted &&
        !widget.confirmationPasswordValidator.isValid(_confirmationPassword);
    return Opacity(
      opacity: _formType == EmailSignInFormType.signIn ? 0 : 1,
      child: TextField(
        controller: _confirmPasswordController,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          enabled: _isLoading == false,
          errorText: showErrorMessage || _confirmationPassword != _password
              ? widget.invalidConfirmationPasswordErrorText
              : null,
        ),
        obscureText: true,
        onChanged: (email) => _updateSetState(),
        focusNode: _confirmPasswordFocusNode,
        onEditingComplete: () => _submit(),
      ),
    );
  }

  Widget _buildEmailTextField() {
    bool showErrorMessage =
        _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        enabled: _isLoading == false,
        hintText: 'user@test.com',
        errorText: showErrorMessage ? widget.invalidEmailErrorText : null,
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
    bool showErrorMessage =
        _submitted && !widget.passwordValidator.isValid(_password);

    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        enabled: _isLoading == false,
        errorText: showErrorMessage ? widget.invalidPasswordErrorText : null,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => _updateSetState(),
      onEditingComplete: () => _formType == EmailSignInFormType.signIn
          ? _submit()
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
            children: _buildChildren(),
          ),
        ],
      ),
    );
  }

  _updateSetState() {
    setState(() {});
  }
}