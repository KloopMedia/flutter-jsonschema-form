import 'package:flutter/material.dart';

import '../widgets/field_wrapper.dart';
import 'models.dart';

class Section extends ComplexField {
  final List<Field> fields;

  Section({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    required this.fields,
  });

  @override
  Section copyWith({String? id, PathModel? path}) {
    return Section(
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
  Widget build() {
    return FieldWrapper.section(title: title, description: description);
  }
}
