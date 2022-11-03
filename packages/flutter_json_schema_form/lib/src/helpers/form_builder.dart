import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart' as bloc;
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'helpers.dart';

class FormBuilder extends StatelessWidget {
  final List<FieldModel> fields;
  final List<Dependency> dependencies;

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
            return DependencyWidget(model: model);
          },
        ),
      ],
    );
  }
}

class DependencyWidget extends StatelessWidget {
  final Dependency model;

  const DependencyWidget({Key? key, required this.model}) : super(key: key);

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
      // buildWhen: (previousState, currentState) {
      //   final value = getFormDataByPath(currentState.formData, PathModel(parentPath));
      //   return model.values.contains(value);
      // },
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
    return TextWidget(model: model);
  } else if (model is Section) {
    return SectionWidget(model: model);
  } else if (model is Array) {
    return ArrayWidget(model: model);
  }
  return const Text('Error: widget not found');
}
