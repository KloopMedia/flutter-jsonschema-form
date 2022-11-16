import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;
import '../../widgets/widgets.dart';
import '../fields.dart';

class TextField extends StatefulWidget {
  final TextFieldModel model;
  final DependencyModel? dependency;
  final String? value;

  const TextField({Key? key, required this.model, required this.value, this.dependency})
      : super(key: key);

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  late final id = widget.model.id;
  late final path = widget.model.path;
  late final title = widget.model.fieldTitle;
  late final description = widget.model.description;
  late final type = widget.model.fieldType;
  late final widgetType = widget.model.widgetType;
  late final isRequired = widget.model.isRequired;
  late final defaultValue = widget.model.defaultValue;
  late bloc.FormBloc _bloc;

  void onChange(value) {
    _bloc.add(bloc.ChangeFormEvent(id, value, path));
  }

  String? validator(value) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'Required';
    }
    return null;
  }

  @override
  void initState() {
    _bloc = context.read<bloc.FormBloc>();
    if (defaultValue != null && widget.value == null) {
      onChange(defaultValue);
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

    try {
      bool isArrayItem = path.path[path.path.length - 2].fieldType == FieldType.array;
      if (isArrayItem) {
        _bloc.add(bloc.ChangeFormEvent(id, widget.value, path, true));
      }
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FieldWrapper(
      title: title,
      description: description,
      isRequired: isRequired,
      child: Builder(builder: (context) {
        final value = widget.value ?? defaultValue;
        if (widgetType == WidgetType.select) {
          return SelectWidget<String>(
            value: value,
            items: widget.model.dropdownItems,
            onChange: onChange,
          );
        } else if (widgetType == WidgetType.radio) {
          return RadioWidget<String>(
            value: value,
            items: widget.model.radioItems,
            onChange: onChange,
          );
        } else if (widgetType == WidgetType.textarea) {
          return TextWidget(
            value: value,
            validator: validator,
            textArea: true,
            onChange: onChange,
          );
        } else {
          return TextWidget(
            value: value,
            validator: validator,
            onChange: onChange,
          );
        }
      }),
    );
  }
}
