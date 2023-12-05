import 'package:flutter/material.dart';

final defaultFieldDecoration = InputDecoration(
  isDense: true,
  filled: true,
  fillColor: Colors.white,
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
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(width: 1.0, color: Color(0xFF8E9192)),
    borderRadius: BorderRadius.circular(15),
  ),
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

const _correctColorBorder = Color.fromRGBO(116, 191, 59, 1);
final _correctOutlineInputBorder = OutlineInputBorder(
  borderSide: const BorderSide(width: 1, color: _correctColorBorder),
  borderRadius: BorderRadius.circular(15),
);

final correctFormDataDecoration = defaultFieldDecoration.copyWith(
  border: _correctOutlineInputBorder,
  enabledBorder: _correctOutlineInputBorder,
  focusedBorder: _correctOutlineInputBorder,
  disabledBorder: _correctOutlineInputBorder,
);

const _errorColorBorder = Color.fromRGBO(255, 137, 125, 1);
final _errorOutlineInputBorder = OutlineInputBorder(
  borderSide: const BorderSide(width: 1, color: _errorColorBorder),
  borderRadius: BorderRadius.circular(15),
);

final wrongFormDataDecoration = defaultFieldDecoration.copyWith(
  border: _errorOutlineInputBorder,
  enabledBorder: _errorOutlineInputBorder,
  focusedBorder: _errorOutlineInputBorder,
  disabledBorder: _errorOutlineInputBorder,
);

const _correctContainerColor = Color.fromRGBO(116, 191, 59, 0.15);
const correctContainerDecoration = BoxDecoration(
  color: _correctContainerColor,
  borderRadius: BorderRadius.all(Radius.circular(15)),
);

const _errorContainerColor = Color.fromRGBO(255, 137, 125, 0.15);
const wrongContainerDecoration = BoxDecoration(
  color: _errorContainerColor,
  borderRadius: BorderRadius.all(Radius.circular(15)),
);

InputDecoration showCorrectFieldDecoration(bool? isCorrect) {
  if (isCorrect == null) {
    return defaultFieldDecoration;
  }

  if (isCorrect) {
    return correctFormDataDecoration;
  } else {
    return wrongFormDataDecoration;
  }
}

BoxDecoration? showCorrectContainerDecoration(bool? isCorrect) {
  if (isCorrect == null) {
    return null;
  }

  if (isCorrect) {
    return correctContainerDecoration;
  } else {
    return wrongContainerDecoration;
  }
}
