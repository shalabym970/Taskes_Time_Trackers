import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tasks_time_tracker/widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    required String text,
    required String picLogo,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(picLogo),
              const SizedBox(width: 10),
              Text(text, style: TextStyle(color: textColor, fontSize: 15)),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
