import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart' as bloc;
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../fields.dart';

class NumberField extends StatefulWidget {
  final NumberFieldModel model;
  final DependencyModel? dependency;
  final num? value;

  const NumberField({Key? key, required this.model, required this.value, this.dependency})
      : super(key: key);

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  // late final id = widget.model.id;
  // late final path = widget.model.path;
  // late final title = widget.model.fieldTitle;
  // late final description = widget.model.description;
  // late final type = widget.model.fieldType;
  // late final widgetType = widget.model.widgetType;
  // late final isRequired = widget.model.isRequired;
  // late final defaultValue = widget.model.defaultValue;
  // late final value = widget.value ?? defaultValue;
  // late final disabled = widget.model.disabled;
  // late final readOnly = widget.model.readOnly;
  late bloc.FormBloc _bloc;

  num? parseValue(value) {
    num? parsedValue;
    if (value != null) {
      try {
        if (widget.model.fieldType == FieldType.number) {
          parsedValue = double.tryParse(value);
        }
        if (widget.model.fieldType == FieldType.integer) {
          parsedValue = int.tryParse(value);
        }
      } on TypeError {
        parsedValue = value is num ? value : null;
      }
    }
    return parsedValue;
  }

  void onChange(value) {
    final parsedValue = parseValue(value);
    _bloc.add(bloc.ChangeFormEvent(widget.model.id, parsedValue, widget.model.path));
  }

  String? validator(value) {
    final parsedValue = parseValue(value);
    if (widget.model.isRequired && parsedValue == null) {
      return 'Required';
    }
    return null;
  }

  @override
  void initState() {
    _bloc = context.read<bloc.FormBloc>();
    if (widget.model.defaultValue != null) {
      final formData = context.read<bloc.FormBloc>().state.formData;
      final value = getFormDataByPath(formData, widget.model.path);
      if (value == null) {
        onChange(widget.model.defaultValue);
      }
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = context.read<bloc.FormBloc>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    final dependency = widget.dependency;
    if (dependency != null) {
      final formData = _bloc.state.formData;
      final parentValue = getFormDataByPath(formData, dependency.parentPath);

      if (!dependency.values.contains(parentValue)) {
        _bloc.add(bloc.ChangeFormEvent(widget.model.id, widget.value, widget.model.path, true, true));
      }
    }

    try {
      bool isArrayItem = widget.model.path.path[widget.model.path.path.length - 2].fieldType == FieldType.array;
      if (isArrayItem) {
        _bloc.add(bloc.ChangeFormEvent(widget.model.id, widget.value, widget.model.path, true));
      }
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalDisabled = context.read<bloc.FormBloc>().state.disabled;

    return FieldWrapper(
      title: widget.model.fieldTitle,
      description: widget.model.description,
      isRequired: widget.model.isRequired,
      child: Builder(
        builder: (context) {
          if (widget.model.widgetType is NullWidgetModel) {
            return DefaultWidgetBuilder(
              id: widget.model.id,
              fieldType: widget.model.fieldType,
              value: widget.value ?? widget.model.defaultValue,
              onChange: onChange,
              disabled: globalDisabled || widget.model.disabled,
              readOnly: widget.model.readOnly,
              isRequired: widget.model.isRequired,
            );
          } else {
            return FormWidgetBuilder<num>(
              id: widget.model.id,
              widgetType: widget.model.widgetType,
              value: widget.value ?? widget.model.defaultValue,
              onChange: onChange,
              dropdownItems: widget.model.getDropdownItems(),
              radioItems: widget.model.getRadio(),
              disabled: globalDisabled || widget.model.disabled,
              readOnly: widget.model.readOnly,
              isRequired: widget.model.isRequired,
            );
          }
        },
      ),
    );
  }
}
