import 'package:flutter/material.dart';

final decoration = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: Color(0xFFA9ACAC)),
    borderRadius: BorderRadius.circular(15),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.blueAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(15),
  ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(width: 1.0, color:  Color(0xFF8E9192)),
  // ),
  disabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(width: 1.0, color: Color(0xFFA9ACAC)),
    borderRadius: BorderRadius.circular(15),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.redAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(15),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.redAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(15),
  ),
);
