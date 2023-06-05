import 'package:flutter/material.dart';

class ParagraphField extends StatelessWidget {
  final String name;
  final InputDecoration decoration;
  final dynamic initialValue;
  final String paragraph;

  const ParagraphField({
    Key? key,
    required this.name,
    required this.decoration,
    required this.initialValue,
    required this.paragraph,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(paragraph);
  }
}
