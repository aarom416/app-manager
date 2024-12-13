import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

/// 기본 스낵바
void showDefaultSnackBar(BuildContext context, String message, {int seconds = 2}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds),
    ),
  );
}

void showGlobalSnackBar(BuildContext context, String message,
    {Color backgroundColor = const Color(0xFF005832)}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: const Duration(seconds: 2),
  );

  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);

  Navigator.pop(context);
}

void showGlobalSnackBarWithoutContext(String message,
    {Color backgroundColor = const Color(0xFF005832)}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    duration: const Duration(seconds: 2),
  );

  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}