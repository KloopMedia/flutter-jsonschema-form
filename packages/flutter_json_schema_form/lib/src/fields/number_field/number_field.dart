import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
    num? parsedValue;
    if (value != null) {
      try {
        if (type == FieldType.number) {
          parsedValue = double.tryParse(value);
        }
        if (type == FieldType.integer) {
          parsedValue = int.tryParse(value);
        }
      } on TypeError {
        parsedValue = value is num ? value : null;
      }
    }
    _bloc.add(bloc.ChangeFormEvent(id, parsedValue, path));
  }

  String? validator(value) {
    print('$id ${value}');
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
    return FieldWrapper(
      title: title,
      description: description,
      isRequired: isRequired,
      child: Builder(
        builder: (context) {
          if (widgetType == WidgetType.select) {
            return FormBuilderDropdown(
              name: id,
              initialValue: value,
              decoration: decoration,
              validator: validator,
              items: widget.model.dropdownItems,
              onChanged: onChange,
            );
          } else if (widgetType == WidgetType.radio) {
            return FormBuilderRadioGroup<num>(
              name: id,
              initialValue: value,
              decoration: decoration,
              orientation: OptionsOrientation.vertical,
              validator: validator,
              options: widget.model.getRadio(),
              onChanged: onChange,
            );
          } else {
            return FormBuilderTextField(
              name: id,
              initialValue: value?.toString(),
              decoration: decoration,
              validator: validator,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: onChange,
            );
          }
        },
      ),
    );
  }
}
