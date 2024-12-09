import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 기본 스낵바
void showDefaultSnackBar(BuildContext context, String message, {int seconds = 2}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds),
    ),
  );
}