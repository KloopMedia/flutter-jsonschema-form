import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import 'models.dart';

abstract class Field {
  final String id;
  final PathModel path;
  final FieldType type;
  final String? title;
  final String? description;
  final Dependency? dependency;

  Field({
    required this.id,
    required this.path,
    required this.type,
    this.title,
    this.description,
    this.dependency,
  });

  bool get hasTitleOrDescription => title != null || description != null;

  bool get hasDependency => dependency != null;

  bool shouldRenderDependency(Map<String, dynamic> formData) {
    return dependency?.shouldRenderDependency(formData) ?? true;
  }

  Field copyWith({String? id, PathModel? path});

  Widget build(BuildContext context);
}
