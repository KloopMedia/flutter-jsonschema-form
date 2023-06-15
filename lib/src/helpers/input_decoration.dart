import 'package:flutter/material.dart';

const decoration = InputDecoration(
  isDense: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blueAccent,
      width: 1.0,
    ),
  ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(width: 1.0, color:  Color(0xFF8E9192)),
  // ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
      width: 1.0,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.redAccent,
      width: 1.0,
    ),
  ),
);
