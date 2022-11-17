import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart' as bloc;
import '../fields/fields.dart' as form_fields;
import '../models/models.dart';
import 'helpers.dart';

class FormConstructor extends StatelessWidget {
  final List<FieldModel> fields;
  final List<DependencyModel> dependencies;
  final List<String>? order;

  const FormConstructor({
    Key? key,
    required this.fields,
    required this.dependencies,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sorted = sortFields(fields, order!);
    final newList = insertDependencies(sorted, dependencies);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newList.length,
      itemBuilder: (context, index) {
        final model = newList[index];
        if (model is SectionModel) {
          return form_fields.SectionField(model: model);
        } else if (model is ArrayModel) {
          return form_fields.ArrayField(model: model);
        } else if (model is DependencyModel) {
          final field = model.field;

          if (field == null) {
            return const SizedBox.shrink();
          }

          if (field is SectionModel) {
            return form_fields.SectionField(model: field);
          } else if (field is ArrayModel) {
            return form_fields.ArrayField(model: field);
          } else {
            return DependencyBuilder(model: model);
          }
        } else {
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

class DependencyBuilder extends StatelessWidget {
  final DependencyModel model;

  const DependencyBuilder({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final field = model.field!;
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

class ArrayBuilder extends StatelessWidget {
  final List<FieldModel> fields;
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

Widget _mapModelToField(FieldModel model, dynamic value, [DependencyModel? dependency]) {
  if (model is TextFieldModel) {
    return form_fields.TextField(model: model, value: value, dependency: dependency);
  } else if (model is NumberFieldModel) {
    return form_fields.NumberField(model: model, value: value, dependency: dependency);
  } else if (model is BooleanFieldModel) {
    return form_fields.BooleanField(model: model, value: value, dependency: dependency);
  }
  return const Text('Error: Field not found');
}

List<FieldModel> sortFields(List<FieldModel> fields, List<String>? order) {
  if (order == null) {
    return fields;
  }
  final Map<String, FieldModel> fieldSchema = Map.fromIterable(fields, key: (field) => field.id);
  final other = fieldSchema.keys.where((element) => !order.contains(element));
  var orderSchema = List.of(order);
  if (order.contains('*')) {
    final wildCardIndex = order.indexOf('*');
    orderSchema.insertAll(wildCardIndex, other);
    orderSchema.remove('*');
  } else {
    orderSchema.addAll(other);
  }
  List<FieldModel> sortedFields = [];
  for (var element in orderSchema) {
    final field = fieldSchema[element];
    if (field != null) {
      sortedFields.add(field);
    }
  }
  return sortedFields;
}

List<dynamic> insertDependencies(List<FieldModel> fields, List<DependencyModel> dependencies) {
  final newFields = List.from(fields);
  for (var dependency in dependencies) {
    final index = fields.indexWhere((field) => field.id == dependency.parentId);
    if (!index.isNegative) {
      newFields.insert(index + 1, dependency);
    }
  }
  return newFields;
}
