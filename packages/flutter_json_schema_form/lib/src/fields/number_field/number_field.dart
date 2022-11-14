import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;
import '../../widgets/widgets.dart';
import '../fields.dart';

class NumberField extends StatefulWidget {
  final NumberFieldModel model;

  const NumberField({Key? key, required this.model}) : super(key: key);

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

  void onChange(BuildContext context, value) {
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, value, path));
  }

  @override
  Widget build(BuildContext context) {
    return FieldWrapper(
      title: title,
      description: description,
      isRequired: isRequired,
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        // buildWhen: (previousState, currentState) {
        //   return previousState.formData[id] != currentState.formData[id];
        // },
        builder: (context, state) {
          final value = getFormDataByPath(state.formData, path);
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
              onChange: (newValue) {
                print(newValue);
                onChange(context, newValue);
              },
            );
          } else {
            return NumberWidget<int>(
              value: value,
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
