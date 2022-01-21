import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton(
      {this.child,
      this.color,
      this.borderRadius = 2.0,
      this.onPressed,
      this.height = 50});

  final Widget? child;
  final Color? color;
  final double? height;
  final double? borderRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(borderRadius!),
        )),
        onPressed: onPressed,
      ),
    );
  }
}
