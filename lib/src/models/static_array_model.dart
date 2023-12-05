import 'package:flutter/material.dart';

import 'models.dart';

class StaticArray extends ArrayField {
  final List<Field> fields;

  StaticArray({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    required this.fields,
  });

  @override
  StaticArray copyWith({String? id, PathModel? path}) {
    return StaticArray(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type,
      fields: fields,
      title: title,
      description: description,
      dependency: dependency,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text('$id $title');
  }
}
