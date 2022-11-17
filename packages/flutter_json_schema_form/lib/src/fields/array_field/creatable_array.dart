import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../bloc/bloc.dart' as bloc;

class CreatableArray extends StatefulWidget {
  final ArrayModel model;

  const CreatableArray({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<CreatableArray> createState() => _CreatableArrayState();
}

class _CreatableArrayState extends State<CreatableArray> {
  late final FieldModel fieldModel = widget.model.itemType!;
  List<FieldModel> fields = [];

  void addItemToArray() {
    final id = fields.length.toString();
    final field = createArrayItemFromModel(fieldModel, id);
    setState(() {
      fields.add(field);
    });
  }

  FieldModel createArrayItemFromModel(FieldModel model, String id) {
    final List<PathItem> pathList = List.from(model.path.path);
    pathList[pathList.length - 1] = PathItem(id, model.fieldType);
    if (model is TextFieldModel) {
      return model.copyWith(id: id, path: PathModel(pathList));
    }
    if (model is NumberFieldModel) {
      return model.copyWith(id: id, path: PathModel(pathList));
    }
    if (model is BooleanFieldModel) {
      return model.copyWith(id: id, path: PathModel(pathList));
    }
    return model;
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
                  onPressed: addItemToArray,
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: fields.isNotEmpty ? removeItemFromArray : null,
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
