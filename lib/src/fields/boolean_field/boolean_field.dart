import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart' as bloc;
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../fields.dart';

class BooleanField extends StatefulWidget {
  final BooleanFieldModel model;
  final DependencyModel? dependency;
  final bool? value;

  const BooleanField({Key? key, required this.model, this.value, this.dependency})
      : super(key: key);

  @override
  State<BooleanField> createState() => _BooleanFieldState();
}

class _BooleanFieldState extends State<BooleanField> {
  late final id = widget.model.id;
  late final path = widget.model.path;
  late final title = widget.model.fieldTitle;
  late final description = widget.model.description;
  late final type = widget.model.fieldType;
  late final widgetType = widget.model.widgetType;
  late final isRequired = widget.model.isRequired;
  late final defaultValue = widget.model.defaultValue;
  late final value = widget.value ?? defaultValue;
  late final disabled = widget.model.disabled;
  late final readOnly = widget.model.readOnly;
  late bloc.FormBloc _bloc;

  void onChange(value) {
    _bloc.add(bloc.ChangeFormEvent(id, value, path));
  }

  String? validator(value) {
    if (isRequired && value == null) {
      return 'Required';
    }
    return null;
  }

  @override
  void initState() {
    _bloc = context.read<bloc.FormBloc>();
    if (defaultValue != null) {
      final formData = context.read<bloc.FormBloc>().state.formData;
      final value = getFormDataByPath(formData, path);
      if (value == null) {
        onChange(defaultValue);
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
        _bloc.add(bloc.ChangeFormEvent(id, widget.value, path, true, true));
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
    final globalDisabled = context.read<bloc.FormBloc>().state.disabled;

    if (widgetType is NullWidgetModel) {
      return DefaultWidgetBuilder(
        id: id,
        fieldType: type,
        value: value,
        onChange: onChange,
        title: title,
        disabled: globalDisabled || disabled,
        readOnly: readOnly,
        isRequired: isRequired,
      );
    } else {
      return FieldWrapper(
        title: title,
        description: description,
        isRequired: isRequired,
        child: FormWidgetBuilder<bool>(
          id: id,
          widgetType: widgetType,
          value: value,
          onChange: onChange,
          dropdownItems: widget.model.getDropdownItems(),
          radioItems: widget.model.getRadio(),
          disabled: globalDisabled || disabled,
          readOnly: readOnly,
          isRequired: isRequired,
        ),
      );
    }
  }
}
