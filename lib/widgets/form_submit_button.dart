import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks_time_tracker/widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    VoidCallback? onPressed,
    required String text,
  }) : super(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          height: 44,
          color: Colors.indigo,
          borderRadius: 4,
          onPressed: onPressed,
        );
}