import 'package:flutter/material.dart';

const decoration = InputDecoration(
  isDense: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blueAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color:  Color(0xFFA9ACAC),
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFFF897D),
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFFF897D),
      width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
