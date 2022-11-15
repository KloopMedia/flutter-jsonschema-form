import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;
import '../../widgets/widgets.dart';
import '../fields.dart';

class NumberField extends StatefulWidget {
  final NumberFieldModel model;
  final DependencyModel? dependency;
  final double? value;

  const NumberField({Key? key, required this.model, required this.value, this.dependency})
      : super(key: key);

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  late final id = widget.model.id;
  late final path = widget.model.path;
  late final title = widget.model.fieldTitle;
  late final description = widget.model.description;
  late final type = widget.model.fieldType;
  late final widgetType = widget.model.widgetType;
  late final isRequired = widget.model.isRequired;
  late final defaultValue = widget.model.defaultValue;
  late final bloc.FormBloc _bloc;

  void onChange(BuildContext context, value) {
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, value, path));
  }

  String? validator(String? value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'Required';
    }
    return null;
  }

  @override
  void initState() {
    if (defaultValue != null) {
      final formData = context.read<bloc.FormBloc>().state.formData;
      final value = getFormDataByPath(formData, path);
      if (value == null) {
        onChange(context, defaultValue);
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
        _bloc.add(bloc.ChangeFormEvent(id, widget.value, path, true));
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FieldWrapper(
      title: title,
      description: description,
      isRequired: isRequired,
      child: Builder(
        builder: (context) {
          final value = widget.value ?? defaultValue;

          if (widgetType == WidgetType.select) {
            return SelectWidget<double>(
              value: value,
              items: widget.model.dropdownItems,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            );
          } else if (widgetType == WidgetType.radio) {
            return RadioWidget<double>(
              value: value,
              items: widget.model.radioItems,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            );
          } else if (type == FieldType.number) {
            return NumberWidget<double>(
              value: value,
              validator: validator,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            );
          } else {
            return NumberWidget<int>(
              value: value?.toInt(),
              validator: validator,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            );
          }
        },
      ),
    );
  }
}
