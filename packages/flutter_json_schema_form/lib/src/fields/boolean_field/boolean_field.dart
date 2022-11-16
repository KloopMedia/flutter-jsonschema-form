import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
        _bloc.add(bloc.ChangeFormEvent(id, widget.value, path, true));
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (widgetType == WidgetType.select) {
        return FieldWrapper(
          title: title,
          description: description,
          isRequired: isRequired,
          child: FormBuilderDropdown(
            name: id,
            initialValue: value,
            decoration: decoration,
            validator: validator,
            items: widget.model.dropdownItems,
            onChanged: onChange,
          ),
        );
      } else if (widgetType == WidgetType.radio) {
        return FieldWrapper(
          title: title,
          description: description,
          isRequired: isRequired,
          child: FormBuilderRadioGroup<bool>(
            name: id,
            initialValue: value,
            decoration: decoration,
            orientation: OptionsOrientation.vertical,
            validator: validator,
            options: widget.model.getRadio(),
            onChanged: onChange,
          ),
        );
      } else {
        return FormBuilderCheckbox(
          name: id,
          title: Text(title),
          initialValue: value,
          onChanged: onChange,
        );
      }
    });
  }
}
