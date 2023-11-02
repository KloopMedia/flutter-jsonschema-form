import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart' as bloc;
import '../helpers/form_data_helper.dart';
import '../widgets/field_wrapper.dart';
import 'models.dart';

class DynamicArray extends ArrayField {
  final Field field;

  DynamicArray({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    required this.field,
  });

  @override
  DynamicArray copyWith({String? id, PathModel? path}) {
    return DynamicArray(
      id: id ?? this.id,
      path: path ?? this.path,
      field: field,
      type: type,
      title: title,
      description: description,
      dependency: dependency,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FieldWrapper.section(
      title: title,
      description: description,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        buildWhen: (previous, current) => shouldRebuildBloc(this, previous, current),
        builder: (context, state) {
          final value = getFormDataByPath(state.formData, path);
          final array = value is List ? value : [];

          return Column(
            children: [
              ...array.asMap().entries.map((e) {
                final index = e.key;
                final value = e.value;

                final arrayPath = path.add(index.toString(), field.type);
                final arrayField = field.copyWith(id: "${id}_$index", path: arrayPath);
                if (arrayField is ValueField) {
                  return arrayField.copyWith(defaultValue: value).build(context);
                } else {
                  return arrayField.build(context);
                }
              }),
              ElevatedButton(
                onPressed: () {
                  final value = field is ValueField ? (field as ValueField).defaultValue : null;
                  final newArray = [...array, value];
                  context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, newArray, path));
                },
                child: Text('+'),
              )
            ],
          );
        },
      ),
    );
  }
}
