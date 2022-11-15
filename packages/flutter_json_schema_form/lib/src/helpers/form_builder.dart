import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';
import '../fields/fields.dart' as fields;
import '../bloc/bloc.dart' as bloc;
import 'helpers.dart';

class FormBuilder extends StatelessWidget {
  final List<FieldModel> fields;
  final List<DependencyModel> dependencies;

  const FormBuilder({
    Key? key,
    required this.fields,
    required this.dependencies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: fields.length,
          itemBuilder: (context, index) {
            final model = fields[index];
            return FieldBuilder(model: model);
          },
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dependencies.length,
          itemBuilder: (context, index) {
            final model = dependencies[index];
            return DependencyBuilder(model: model);
          },
        ),
      ],
    );
  }
}

class FieldBuilder extends StatelessWidget {
  final FieldModel model;

  const FieldBuilder({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      builder: (context, state) {
        final value = getFormDataByPath(state.formData, model.path);
        return _mapModelToField(model, value);
      },
    );
  }
}

class DependencyBuilder extends StatelessWidget {
  final DependencyModel model;

  const DependencyBuilder({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final field = model.field;

    if (field == null) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      builder: (context, state) {
        final parentValue = getFormDataByPath(state.formData, model.parentPath);
        if (model.values.contains(parentValue)) {
          final value = getFormDataByPath(state.formData, field.path);
          return _mapModelToField(field, value, model);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

Widget _mapModelToField(FieldModel model, dynamic value, [DependencyModel? dependency]) {
  if (model is TextFieldModel) {
    return fields.TextField(model: model, value: value, dependency: dependency);
  } else if (model is SectionModel) {
    return fields.SectionField(model: model);
  } else if (model is ArrayModel) {
    return fields.ArrayWidget(model: model);
  } else if (model is NumberFieldModel) {
    return fields.NumberField(model: model, value: value, dependency: dependency);
  } else if (model is BooleanFieldModel) {
    return fields.BooleanField(model: model, value: value, dependency: dependency);
  }
  return const Text('Error: Field not found');
}
