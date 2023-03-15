import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;

class DynamicArray extends StatefulWidget {
  final DynamicArrayModel model;

  const DynamicArray({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<DynamicArray> createState() => _DynamicArrayState();
}

class _DynamicArrayState extends State<DynamicArray> {
  late final BaseModel fieldModel = widget.model.itemType;
  List<FieldModel> fields = [];

  void addItemToArray() {
    final id = fields.length.toString();
    final field = createArrayItemFromModel(fieldModel, id);
    setState(() {
      fields.add(field);
    });
  }

  FieldModel createArrayItemFromModel(BaseModel model, String id) {
    final path = model.path.removeLast().add(id, model.fieldType);
    throw UnimplementedError();
    // return model.copyWith(id: id, path: path);
  }

  void removeItemFromArray() {
    setState(() {
      fields.removeLast();
    });
  }

  @override
  void initState() {
    final formBloc = context.read<bloc.FormBloc>();
    final List values = getFormDataByPath(formBloc.state.formData, widget.model.path) ?? [];

    if (values.isNotEmpty) {
      for (var _ in values) {
        addItemToArray();
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.FormBloc, bloc.FormState>(
      builder: (context, state) {
        final globalDisabled = state.disabled;
        final List values = getFormDataByPath(state.formData, widget.model.path) ?? [];
        return Column(
          children: [
            ArrayBuilder(
              fields: fields,
              values: values,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: globalDisabled ? null : addItemToArray,
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: globalDisabled || fields.isEmpty ? null : removeItemFromArray,
                  child: const Text('-'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
