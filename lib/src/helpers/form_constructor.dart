import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart' as bloc;
import '../fields/fields.dart' as form_fields;
import '../models/models.dart';
import 'helpers.dart';

class FormConstructor extends StatelessWidget {
  final List<dynamic> fields;

  const FormConstructor({
    Key? key,
    required this.fields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fields.length,
      itemBuilder: (context, index) {
        final model = fields[index];
        if (model is SectionModel) {
          return form_fields.SectionField(model: model);
        } else if (model is ArrayModel) {
          return form_fields.ArrayField(model: model);
        }
        // else if (model is DependencyModel) {
        //   if (model.field == null) {
        //     return const SizedBox.shrink();
        //   }
        //   return DependencyBuilder(model: model);
        // }
        else {
          return FieldBuilder(model: model);
        }
      },
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

// class DependencyBuilder extends StatelessWidget {
//   final DependencyModel model;
//
//   const DependencyBuilder({Key? key, required this.model}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final field = model.field!;
//     return BlocBuilder<bloc.FormBloc, bloc.FormState>(
//       builder: (context, state) {
//         final parentValue = getFormDataByPath(state.formData, model.parentPath);
//         if (model.values.contains(parentValue)) {
//           final value = getFormDataByPath(state.formData, field.path);
//           return _mapModelToField(field, value, model);
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }
// }

class ArrayBuilder extends StatelessWidget {
  final List<BaseModel> fields;
  final List values;

  const ArrayBuilder({Key? key, required this.fields, required this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fields.length,
      itemBuilder: (context, index) {
        final model = fields[index];
        dynamic value;
        try {
          value = values[index];
        } on RangeError {
          value = null;
        }
        if (model is SectionModel) {
          return form_fields.SectionField(model: model);
        } else if (model is ArrayModel) {
          return form_fields.ArrayField(model: model);
        } else {
          return _mapModelToField(model, value);
        }
      },
    );
  }
}

Widget _mapModelToField(BaseModel model, dynamic value, [DependencyModel? dependency]) {
  if (model is TextFieldModel) {
    final val = value is String? ? value : value.toString();
    return form_fields.TextField(model: model, value: val, dependency: dependency);
  } else if (model is NumberFieldModel) {
    final val = value is num? ? value : num.tryParse(value);
    return form_fields.NumberField(model: model, value: val, dependency: dependency);
  } else if (model is BooleanFieldModel) {
    final val = value is bool? ? value : null;
    return form_fields.BooleanField(model: model, value: val, dependency: dependency);
  } else if (model is SectionModel) {
    return form_fields.SectionField(model: model, value: value, dependency: dependency);
  } else if (model is ArrayModel) {
    return form_fields.ArrayField(model: model);
  }
  return const Text('Error: Field not found');
}
