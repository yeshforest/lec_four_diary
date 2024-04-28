import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text){
  // 스낵바 함수

  final snackBar = SnackBar(
    content: Text(text),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}