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

  Field copyWith({String? id, PathModel? path});

  Widget build();

  bool shouldRenderDependency(Dependency? dependency, Map<String, dynamic> formData) {
    if (dependency == null) {
      return true;
    }

    final data = getFormDataByPath(formData, dependency.parentPath);

    if (!dependency.conditions.contains(data)) {
      return false;
    }

    if (dependency.parentDependency != null) {
      return shouldRenderDependency(dependency.parentDependency!, formData);
    } else {
      return true;
    }
  }
}