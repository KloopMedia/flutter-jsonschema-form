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
    borderSide: const BorderSide(width: 1.0, color:  Color(0xFF8E9192)),
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

final correctFormDataDecoration = defaultFieldDecoration.copyWith(
  border: OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: Colors.green),
    borderRadius: BorderRadius.circular(15),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(width: 1.0, color: Colors.green),
    borderRadius: BorderRadius.circular(15),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.green, width: 1.0),
    borderRadius: BorderRadius.circular(15),
  ),
);

final wrongFormDataDecoration = defaultFieldDecoration.copyWith(
  border: OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: Colors.red),
    borderRadius: BorderRadius.circular(15),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(width: 1.0, color: Colors.red),
    borderRadius: BorderRadius.circular(15),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.circular(15),
  ),
);

const correctContainerDecoration = BoxDecoration(
  color: Color.fromRGBO(233, 244, 226, 1),
  borderRadius: BorderRadius.all(Radius.circular(15)),
);

const wrongContainerDecoration = BoxDecoration(
  color: Color.fromRGBO(248, 236, 234, 1),
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
