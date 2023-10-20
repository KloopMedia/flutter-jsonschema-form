import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/fields/field_wrapper.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/models.dart';
import 'helpers.dart';

class Dependency {
  final String parentId;
  final PathModel parentPath;
  final List<dynamic> conditions;

  Dependency({
    required this.parentId,
    required this.parentPath,
    required this.conditions,
  });
}

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
}

abstract class ValueField<T> extends Field {
  final T? defaultValue;
  final List<T>? enumValues;
  final List<String>? enumNames;
  final bool enabled;
  final bool required;
  final WidgetModel? widgetType;

  ValueField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    this.defaultValue,
    this.enumValues,
    this.enumNames,
    this.enabled = true,
    this.required = false,
    this.widgetType,
  });

  factory ValueField.fromSchema({
    required String id,
    required PathModel path,
    required FieldType type,
    required WidgetModel widget,
    required Dependency? dependency,
    required bool isRequired,
    required Map<String, dynamic> schema,
  }) {
    final title = schema['title'];
    final description = schema['description'];
    final defaultValue = schema['default'];
    final enumValues = schema['enum'];
    final enumNames = schema['enumNames'];

    switch (type) {
      case FieldType.string:
        return StringField(
          id: id,
          path: path,
          type: type,
          widgetType: widget,
          dependency: dependency,
          required: isRequired,
          title: title,
          description: description,
          defaultValue: defaultValue,
          enumNames: enumNames,
          enumValues: enumValues,
        ) as ValueField<T>;
      case FieldType.number:
      case FieldType.integer:
        return NumberField(
          id: id,
          path: path,
          type: type,
          widgetType: widget,
          dependency: dependency,
          required: isRequired,
          title: title,
          description: description,
          defaultValue: defaultValue,
          enumNames: enumNames,
          enumValues: enumValues,
        ) as ValueField<T>;
      case FieldType.boolean:
        return BooleanField(
          id: id,
          path: path,
          type: type,
          widgetType: widget,
          dependency: dependency,
          required: isRequired,
          title: title,
          description: description,
          defaultValue: defaultValue,
          enumNames: enumNames,
          enumValues: enumValues,
        ) as ValueField<T>;
      default:
        throw Exception('Type [$type] not supported');
    }
  }

  Widget build();
}

class StringField extends ValueField<String> {
  StringField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    super.defaultValue,
    super.enumValues,
    super.enumNames,
    super.enabled = true,
    super.required = false,
    super.widgetType,
  });

  @override
  Widget build() {
    return FieldWrapper(
      key: Key(id),
      title: title ?? id,
      description: description,
      isRequired: this.required,
      child: FormBuilderTextField(
        name: id,
        initialValue: defaultValue,
        decoration: decoration,
        validator: FormBuilderValidators.compose([
          if (this.required) FormBuilderValidators.required(),
        ]),
        // onChanged: onChange,
        // style: theme,
      ),
    );
  }
}

class NumberField extends ValueField<num> {
  NumberField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    super.defaultValue,
    super.enumValues,
    super.enumNames,
    super.enabled = true,
    super.required = false,
    super.widgetType,
  });

  @override
  Widget build() {
    return FieldWrapper(
      key: Key(id),
      title: title ?? id,
      description: description,
      isRequired: this.required,
      child: FormBuilderTextField(
        name: id,
        initialValue: defaultValue?.toString(),
        decoration: decoration,
        validator: FormBuilderValidators.compose([
          if (this.required) FormBuilderValidators.required(),
          if (type == FieldType.number) FormBuilderValidators.numeric(),
          if (type == FieldType.integer) FormBuilderValidators.integer(),
        ]),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        // onChanged: onChange,
        // style: theme,
      ),
    );
  }
}

class BooleanField extends ValueField<bool> {
  BooleanField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    super.defaultValue,
    super.enumValues,
    super.enumNames,
    super.enabled = true,
    super.required = false,
    super.widgetType,
  });

  @override
  Widget build() {
    return Transform.scale(
      scale: 1.15,
      alignment: Alignment.centerLeft,
      child: FormBuilderCheckbox(
        name: id,
        title: Text(title ?? id, style: const TextStyle(fontSize: 14)),
        initialValue: defaultValue,
        validator: FormBuilderValidators.compose([
          if (this.required) FormBuilderValidators.required(),
        ]),
        // onChanged: onChange,
        contentPadding: const EdgeInsets.only(right: 30),
      ),
    );
  }
}

abstract class ComplexField extends Field {
  ComplexField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
  });
}

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
}

abstract class ArrayField extends ComplexField {
  ArrayField({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
  });
}

class FixedArray extends ArrayField {
  final List<Field> fields;

  FixedArray({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    required this.fields,
  });
}

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
}

FieldType getFieldType(Map<String, dynamic> schema) {
  final maybeObject = schema.containsKey("properties") ? "object" : null;
  return decodeFieldType(schema['type'] ?? maybeObject);
}

List<String> _getRequiredFields(Map<String, dynamic> schema) {
  if (schema.containsKey('required')) {
    return (schema['required'] as List<dynamic>).cast();
  } else {
    return [];
  }
}

List<String> getOrder(Map<String, dynamic>? uiSchema) {
  if (uiSchema == null || !uiSchema.containsKey('ui:order')) {
    return [];
  }
  return (uiSchema['ui:order'] as List<dynamic>).cast();
}

List<Field> _parseObjectFields(
  Map<String, dynamic> properties,
  List<String> required,
  PathModel path, {
  Map<String, dynamic>? uiSchema,
  Dependency? dependency,
}) {
  final List<Field> subFields = [];

  for (final entry in properties.entries) {
    final id = entry.key;
    final subSchema = entry.value;

    final subField = parseSchema(
      id: id,
      schema: subSchema,
      path: path,
      dependency: dependency,
      isRequired: required.contains(id),
      uiSchema: uiSchema?[id],
    );
    subFields.addAll(subField);
  }

  return subFields;
}

List<Field> _parseDependencyFields(
  Map<String, dynamic> dependencies,
  PathModel path, {
  Map<String, dynamic>? uiSchema,
}) {
  final List<Field> subFields = [];

  for (final entry in dependencies.entries) {
    final dependencyParentId = entry.key;
    final List<Map<String, dynamic>> variants = entry.value['oneOf'];
    for (final variant in variants) {
      final Map<String, dynamic> properties = Map.of(variant['properties']);

      final dependencyParentPath = path.add(dependencyParentId, FieldType.object);
      final List<dynamic> conditions = properties.remove(dependencyParentId)?['enum'] ?? [];
      final objectFromProperties = {...variant, "properties": properties};

      final dependency = Dependency(
        parentId: dependencyParentId,
        parentPath: dependencyParentPath,
        conditions: conditions,
      );

      if (properties.isNotEmpty) {
        final parsedDependencies = parseSchema(
          schema: objectFromProperties,
          path: path,
          dependency: dependency,
          uiSchema: uiSchema,
        );
        subFields.addAll(parsedDependencies);
      }
    }
  }

  return _unwrapDependencies(subFields);
}

Map<String, List<Field>> _createOrderMap(List<Field> fields) {
  final Map<String, List<Field>> orderMap = {};
  for (var field in fields) {
    orderMap.putIfAbsent(field.id, () => []).add(field);
  }
  return orderMap;
}

List<Field> sortFields(
  List<Field> objectFields,
  List<Field> dependencyFields,
  List<String>? order,
) {
  final fields = [...objectFields, ...dependencyFields];

  if (order == null || order.isEmpty) {
    return fields;
  }

  final orderMap = _createOrderMap(fields);

  /// Fields not included in ui:order.
  final other = orderMap.keys.where((element) => !order.contains(element));

  var orderSchema = List.of(order);
  if (order.contains('*')) {
    final wildCardIndex = order.indexOf('*');
    orderSchema.insertAll(wildCardIndex, other);
    orderSchema.remove('*');
  } else {
    orderSchema.addAll(other);
  }
  List<Field> sortedFields = [];
  for (var element in orderSchema) {
    final schemaFields = orderMap[element];
    if (schemaFields != null) {
      sortedFields.addAll(schemaFields);
    }
  }
  for (var dependency in dependencyFields) {
    if (!order.contains(dependency.id)) {
      final index = objectFields.indexWhere((field) => field.id == dependency.dependency?.parentId);
      if (index >= 0) {
        sortedFields.insert(index + 1, dependency);
      }
    }
  }
  return sortedFields;
}

List<Field> _unwrapDependencies(List<Field> dependencies) {
  return dependencies.expand((element) {
    if (element is Section) {
      return element.fields;
    }
    return [element];
  }).toList();
}

List<Field> parseSchema({
  String id = "#",
  required Map<String, dynamic> schema,
  Map<String, dynamic>? uiSchema,
  PathModel path = const PathModel.empty(),
  Dependency? dependency,
  bool? isRequired,
}) {
  final type = getFieldType(schema);

  if (type == FieldType.object) {
    final newPath = id == "#" ? path : path.add(id, FieldType.object);

    final List<String> required = _getRequiredFields(schema);
    final objectFields = _parseObjectFields(
      schema['properties'],
      required,
      newPath,
      uiSchema: uiSchema,
      dependency: dependency,
    );

    List<Field> dependencyFields;
    if (schema['dependencies'] != null) {
      dependencyFields = _parseDependencyFields(
        schema['dependencies'],
        newPath,
        uiSchema: uiSchema,
      );
    } else {
      dependencyFields = [];
    }

    final order = getOrder(uiSchema);
    final subFields = sortFields(objectFields, dependencyFields, order);

    return [
      Section(
        id: id,
        path: path,
        type: type,
        fields: subFields,
        dependency: dependency,
      ),
    ];
  } else {
    final newPath = path.add(id, type);
    return [
      ValueField.fromSchema(
        id: id,
        path: newPath,
        type: type,
        dependency: dependency,
        isRequired: isRequired ?? false,
        widget: WidgetModel.fromUiSchema(uiSchema),
        schema: schema,
      ),
    ];
  }
}

List<Widget> serializeFields(List<Field> fields, Map<String, dynamic> formData) {
  final List<Widget> serializedFields = [];

  for (final field in fields) {
    if (field is Section) {
      if (field.hasTitleOrDescription) {
        serializedFields.add(Text('${field.id} ${field.title}'));
      }
      if (field.hasDependency) {
        final parentValue = getFormDataByPath(formData, field.dependency!.parentPath);
        if (field.dependency!.conditions.contains(parentValue)) {
          serializedFields.addAll(serializeFields(field.fields, formData));
        }
      } else {
        serializedFields.addAll(serializeFields(field.fields, formData));
      }
    } else if (field is FixedArray) {
      serializedFields.add(Text('${field.id} ${field.title}'));
      serializedFields.addAll(serializeFields(field.fields, formData));
    } else if (field is ValueField) {
      if (field.hasDependency) {
        final parentValue = getFormDataByPath(formData, field.dependency!.parentPath);
        if (field.dependency!.conditions.contains(parentValue)) {
          serializedFields.add(field.build());
        }
      } else {
        serializedFields.add(field.build());
      }
    }
  }

  return serializedFields;
}
