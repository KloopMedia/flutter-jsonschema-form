import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart' as bloc;
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
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(builder: (context, state) {
      if (!shouldRenderDependency(state.formData)) {
        return const SizedBox.shrink();
      }

      return FieldWrapper.section(title: title, description: description);
    });
  }
}
