abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidation {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final StringValidator confirmationPasswordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = "Email can't be empty";
  final String invalidPasswordErrorText = "Password can't be empty";
  final String invalidConfirmationPasswordErrorText = "Password confirmation is not match with password";
}