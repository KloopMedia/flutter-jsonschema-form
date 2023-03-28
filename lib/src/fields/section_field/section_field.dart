import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc.dart' as bloc;
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../fields/fields.dart';

class SectionField extends StatefulWidget {
  final SectionModel model;
  final Map? value;
  final DependencyModel? dependency;

  const SectionField({
    Key? key,
    required this.model,
    this.value,
    this.dependency,
  }) : super(key: key);

  @override
  State<SectionField> createState() => _SectionFieldState();
}

class _SectionFieldState extends State<SectionField> {
  // late final title = widget.model.fieldTitle == '#' ? null : widget.model.fieldTitle;
  // late final description = widget.model.description;
  // late final fields = widget.model.fields;
  // late final id = widget.model.id;
  // late final path = widget.model.path;
  late bloc.FormBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = context.read<bloc.FormBloc>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    final dependency = widget.dependency;
    final value = widget.value;
    if (dependency != null && value != null) {
      final formData = _bloc.state.formData;
      final parentValue = getFormDataByPath(formData, dependency.parentPath);

      if (!dependency.values.contains(parentValue)) {
        _bloc.add(bloc.ChangeFormEvent(widget.model.id, null, widget.model.path, true, true));
      }
    }

    try {
      bool isArrayItem = widget.model.path.path[widget.model.path.path.length - 2].fieldType == FieldType.array;
      if (isArrayItem) {
        _bloc.add(bloc.ChangeFormEvent(widget.model.id, null, widget.model.path, true));
      }
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FieldWrapper.section(
      title: widget.model.fieldTitle == '#' ? null : widget.model.fieldTitle,
      description: widget.model.description,
      child: FormConstructor(
        fields: widget.model.fields,
      ),
    );
  }
}
