import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';
import '../fields/fields.dart' as fields;
import '../bloc/bloc.dart' as bloc;
import 'helpers.dart';

class FormBuilder extends StatelessWidget {
  final List<FieldModel> fields;
  final List<DependencyModel> dependencies;

  const FormBuilder({Key? key, required this.fields, required this.dependencies}) : super(key: key);

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
            return _mapModelToWidget(model);
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

class DependencyBuilder extends StatelessWidget {
  final DependencyModel model;

  const DependencyBuilder({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final field = model.field;

    if (field == null) {
      return const SizedBox.shrink();
    }

    final parentPath = [...field.path.path];
    parentPath.removeLast();
    parentPath.add(PathItem(model.parentId, FieldType.string));

    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      builder: (context, state) {
        final value = getFormDataByPath(state.formData, PathModel(parentPath));
        if (model.values.contains(value)) {
          return _mapModelToWidget(field);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

Widget _mapModelToWidget(FieldModel model) {
  if (model is TextFieldModel) {
    return fields.TextField(model: model);
  } else if (model is SectionModel) {
    return fields.SectionField(model: model);
  } else if (model is ArrayModel) {
    return fields.ArrayWidget(model: model);
  } else if (model is NumberFieldModel) {
    return fields.NumberField(model: model);
  }
  return const Text('Error: widget not found');
}
