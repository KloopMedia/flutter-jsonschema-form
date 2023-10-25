import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/bloc/bloc.dart' as bloc;
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

  Field copyWith({String? id, PathModel? path});

  Widget build();
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
    required WidgetModel? widget,
    required Dependency? dependency,
    required bool isRequired,
    required Map<String, dynamic> schema,
  }) {
    final title = schema['title'];
    final description = schema['description'];
    final defaultValue = schema['default'];
    final enumValues = schema['enum'];
    final enumNames = schema['enumNames'];
    final widgetType = widget == null && enumValues != null ? const SelectWidgetModel() : widget;

    switch (type) {
      case FieldType.string:
        return StringField(
          id: id,
          path: path,
          type: type,
          widgetType: widgetType,
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
          widgetType: widgetType,
          dependency: dependency,
          required: isRequired,
          title: title,
          description: description,
          defaultValue: defaultValue,
          enumNames: enumNames,
          enumValues: enumValues,
        ) as ValueField<T>;
      case FieldType.boolean:
        final isMultiChoice = widgetType is SelectWidgetModel || widgetType is RadioWidgetModel;

        return BooleanField(
          id: id,
          path: path,
          type: type,
          widgetType: widgetType,
          dependency: dependency,
          required: isRequired,
          title: title,
          description: description,
          defaultValue: defaultValue,
          enumNames: isMultiChoice ? enumNames ?? const ["Yes", "No"] : null,
          enumValues: isMultiChoice ? const [true, false] : null,
        ) as ValueField<T>;
      default:
        throw Exception('Type [$type] not supported');
    }
  }

  @override
  ValueField copyWith({String? id, PathModel? path, T? defaultValue});

  T? valueTransformer(dynamic value);

  void onChange(BuildContext context, dynamic value) {
    var transformedValue = valueTransformer(value);
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, transformedValue, path));
  }

  List<DropdownMenuItem<T>> getDropdownItems<T>() {
    final options = enumValues ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<DropdownMenuItem<T>> items = List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);

      String name;
      try {
        final enumName = names[index].toString();
        if (enumName.isNotEmpty) {
          name = enumName;
        } else {
          name = value.toString();
        }
      } catch (_) {
        name = value.toString();
      }
      return DropdownMenuItem(value: value, child: Text(name));
    });
    return items;
  }

  List<Map<String, dynamic>> getRadioItems<T>() {
    final options = enumValues ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> items = List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);
      String name;
      try {
        name = names[index].toString();
      } catch (_) {
        name = value.toString();
      }
      return {'value': value, 'name': name};
    });
    return items;
  }

  List<FormBuilderFieldOption<T>> getRadio<T>() {
    final options = enumValues ?? [];
    final names = enumNames ?? [];

    if (options.isEmpty) {
      return [];
    }

    List<FormBuilderFieldOption<T>> items = List.generate(options.length, (index) {
      final T value = _parseValue<T>(options[index]);
      String name;
      try {
        final enumName = names[index].toString();
        if (enumName.isNotEmpty) {
          name = enumName;
        } else {
          name = value.toString();
        }
      } catch (_) {
        name = value.toString();
      }
      return FormBuilderFieldOption(value: value, child: Text(name));
    });
    return items;
  }
}

T _parseValue<T>(dynamic value) {
  try {
    if (T == num) {
      return num.parse(value) as T;
    } else {
      return value;
    }
  } catch (e) {
    return null as T;
  }
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
  StringField copyWith({String? id, PathModel? path, String? defaultValue}) {
    return StringField(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type,
      title: title,
      description: description,
      defaultValue: defaultValue ?? this.defaultValue,
      dependency: dependency,
      enumValues: enumValues,
      enumNames: enumNames,
      enabled: enabled,
      required: this.required,
    );
  }

  @override
  String? valueTransformer(value) {
    return value.isNotEmpty ? value : null;
  }

  @override
  Widget build() {
    return FieldWrapper(
      key: Key(id),
      title: title ?? id,
      description: description,
      isRequired: this.required,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        builder: (context, state) {
          final value = getFormDataByPath(state.formData, path);

          if (widgetType != null) {
            return FormWidgetBuilder(
              id: id,
              widgetType: widgetType!,
              value: value,
              onChange: (value) => onChange(context, value),
              disabled: !enabled,
              isRequired: this.required,
              readOnly: false,
              enumItems: enumValues,
              dropdownItems: getDropdownItems(),
              radioItems: getRadio(),
            );
          }

          return FormBuilderTextField(
            name: id,
            initialValue: value ?? defaultValue,
            decoration: decoration,
            validator: FormBuilderValidators.compose([
              if (this.required) FormBuilderValidators.required(),
            ]),
            onChanged: (value) => onChange(context, value),
            // style: theme,
          );
        },
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
  NumberField copyWith({String? id, PathModel? path, num? defaultValue}) {
    return NumberField(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type,
      title: title,
      description: description,
      defaultValue: defaultValue ?? this.defaultValue,
      dependency: dependency,
      enumValues: enumValues,
      enumNames: enumNames,
      enabled: enabled,
      required: this.required,
    );
  }

  @override
  Widget build() {
    return FieldWrapper(
      key: Key(id),
      title: title ?? id,
      description: description,
      isRequired: this.required,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        builder: (context, state) {
          final value = getFormDataByPath(state.formData, path);

          if (widgetType != null) {
            return FormWidgetBuilder(
              id: id,
              widgetType: widgetType!,
              value: value,
              onChange: (value) => onChange(context, value),
              disabled: !enabled,
              isRequired: this.required,
              readOnly: false,
              enumItems: enumValues,
              dropdownItems: getDropdownItems(),
              radioItems: getRadio(),
            );
          }

          return FormBuilderTextField(
            name: id,
            initialValue: value is num ? value.toString() : value ?? defaultValue?.toString(),
            decoration: decoration,
            validator: FormBuilderValidators.compose([
              if (this.required) FormBuilderValidators.required(),
              if (type == FieldType.number) FormBuilderValidators.numeric(),
              if (type == FieldType.integer) FormBuilderValidators.integer(),
            ]),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => onChange(context, value),
            // style: theme,
          );
        },
      ),
    );
  }

  @override
  num? valueTransformer(value) {
    return value is num ? value : num.tryParse(value);
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
  BooleanField copyWith({String? id, PathModel? path, bool? defaultValue}) {
    return BooleanField(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type,
      title: title,
      description: description,
      defaultValue: defaultValue ?? this.defaultValue,
      dependency: dependency,
      enumValues: enumValues,
      enumNames: enumNames,
      enabled: enabled,
      required: this.required,
    );
  }

  @override
  Widget build() {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      builder: (context, state) {
        final value = getFormDataByPath(state.formData, path);

        if (widgetType != null) {
          return FieldWrapper(
            title: title,
            description: description,
            isRequired: this.required,
            child: FormWidgetBuilder(
              id: id,
              widgetType: widgetType!,
              value: value,
              onChange: (value) => onChange(context, value),
              disabled: !enabled,
              isRequired: this.required,
              readOnly: false,
              enumItems: enumValues,
              dropdownItems: getDropdownItems(),
              radioItems: getRadio(),
            ),
          );
        }

        return Transform.scale(
          scale: 1.15,
          alignment: Alignment.centerLeft,
          child: FormBuilderCheckbox(
            name: id,
            title: Text(title ?? id, style: const TextStyle(fontSize: 14)),
            initialValue: value ?? defaultValue,
            validator: FormBuilderValidators.compose([
              if (this.required) FormBuilderValidators.required(),
            ]),
            onChanged: (value) => onChange(context, value),
            contentPadding: const EdgeInsets.only(right: 30),
          ),
        );
      },
    );
  }

  @override
  bool? valueTransformer(value) {
    return value is bool ? value : bool.tryParse(value);
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
  Widget build() {
    return Text('$id $title');
  }
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

class StaticArray extends ArrayField {
  final List<Field> fields;

  StaticArray({
    required super.id,
    required super.path,
    required super.type,
    super.title,
    super.description,
    super.dependency,
    required this.fields,
  });

  @override
  StaticArray copyWith({String? id, PathModel? path}) {
    return StaticArray(
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
  Widget build() {
    return Text('$id $title');
  }
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
  Widget build() {
    return FieldWrapper.section(
      title: title,
      description: description,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
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
                  return arrayField.copyWith(defaultValue: value).build();
                } else {
                  return arrayField.build();
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

Map<String, dynamic>? _uiSchemaAtIndex(Map<String, dynamic>? uiSchema, String id, int index) {
  final _uiSchema = uiSchema?[id];
  try {
    return _uiSchema != null ? _uiSchema[index] : null;
  } on RangeError {
    return null;
  }
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
  final newPath = id == "#" ? path : path.add(id, type);

  final String? title = schema['title'];
  final String? description = schema['description'];

  if (type == FieldType.object) {
    final List<String> required = _getRequiredFields(schema);
    final objectFields = _parseObjectFields(
      schema['properties'],
      required,
      newPath,
      uiSchema: uiSchema,
      dependency: dependency,
    );

    final List<Field> dependencyFields = schema['dependencies'] != null
        ? _parseDependencyFields(schema['dependencies'], newPath, uiSchema: uiSchema)
        : [];

    final order = getOrder(uiSchema);
    final subFields = sortFields(objectFields, dependencyFields, order);

    return [
      Section(
        id: id,
        path: path,
        type: type,
        fields: subFields,
        dependency: dependency,
        title: title,
        description: description,
      ),
    ];
  } else if (type == FieldType.array) {
    final items = schema['items'];

    if (items is List) {
      final List<Field> subFields = items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final ui = _uiSchemaAtIndex(uiSchema, id, index);
        return parseSchema(id: index.toString(), schema: item, uiSchema: ui, path: newPath).first;
      }).toList();

      return [
        StaticArray(
          id: id,
          path: path,
          type: type,
          fields: subFields,
          title: title,
          description: description,
        )
      ];
    } else if (items is Map<String, dynamic>) {
      final field = parseSchema(schema: items, uiSchema: uiSchema?[id], path: newPath).first;
      return [
        DynamicArray(
          id: id,
          path: newPath,
          type: type,
          field: field,
          title: title,
          description: description,
        )
      ];
    } else {
      throw Exception('Incorrect type of items in $id');
    }
  } else {
    return [
      ValueField.fromSchema(
        id: id,
        path: newPath,
        type: type,
        dependency: dependency,
        isRequired: isRequired ?? false,
        widget: getWidgetModelFromUiSchema(uiSchema),
        schema: schema,
      ),
    ];
  }
}

List<Field> serializeFields(List<Field> fields, Map<String, dynamic> formData) {
  final List<Field> serializedFields = [];

  for (final field in fields) {
    if (field is Section) {
      if (field.hasTitleOrDescription) {
        serializedFields.add(field);
      }
      if (field.hasDependency) {
        final parentValue = getFormDataByPath(formData, field.dependency!.parentPath);
        if (field.dependency!.conditions.contains(parentValue)) {
          serializedFields.addAll(serializeFields(field.fields, formData));
        }
      } else {
        serializedFields.addAll(serializeFields(field.fields, formData));
      }
    } else if (field is DynamicArray) {
      serializedFields.add(field);
    } else if (field is StaticArray) {
      serializedFields.add(field);
      serializedFields.addAll(serializeFields(field.fields, formData));
    } else if (field is ValueField) {
      if (field.hasDependency) {
        final parentValue = getFormDataByPath(formData, field.dependency!.parentPath);
        if (field.dependency!.conditions.contains(parentValue)) {
          serializedFields.add(field);
        }
      } else {
        serializedFields.add(field);
      }
    }
  }

  return serializedFields;
}
