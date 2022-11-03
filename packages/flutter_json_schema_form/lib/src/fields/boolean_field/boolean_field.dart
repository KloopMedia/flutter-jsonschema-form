import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_json_schema_form/src/widgets/checkbox_widget.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;
import '../../widgets/widgets.dart';
import '../fields.dart';

class BooleanField extends StatefulWidget {
  final BooleanFieldModel model;

  const BooleanField({Key? key, required this.model}) : super(key: key);

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

  void onChange(BuildContext context, value) {
    context.read<bloc.FormBloc>().add(bloc.ChangeFormEvent(id, value, path));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      // buildWhen: (previousState, currentState) {
      //   return previousState.formData[id] != currentState.formData[id];
      // },
      builder: (context, state) {
        final value = getFormDataByPath(state.formData, path);
        if (widgetType == WidgetType.select) {
          return FieldWrapper(
            title: title,
            description: description,
            child: SelectWidget<bool>(
              value: value,
              items: widget.model.dropdownItems,
              onChange: (newValue) {
                onChange(context, newValue);
              },
            ),
          );
        } else if (widgetType == WidgetType.radio) {
          return FieldWrapper(
            title: title,
            description: description,
            child: RadioWidget<bool>(
              value: value,
              items: widget.model.getRadioItems(),
              onChange: (newValue) {
                onChange(context, newValue);
              },
            ),
          );
        } else {
          return CheckboxWidget(
            title: title,
            description: description,
            value: value,
            onChange: (newValue) {
              onChange(context, newValue);
            },
          );
        }
      },
    );
  }
}
