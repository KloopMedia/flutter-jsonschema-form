import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';

class CreatableArray extends StatefulWidget {
  final FieldModel model;

  const CreatableArray({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<CreatableArray> createState() => _CreatableArrayState();
}

class _CreatableArrayState extends State<CreatableArray> {
  List<FieldModel> fields = [];

  void addItemToArray() {
    final id = fields.length.toString();
    final field = createArrayItemFromModel(widget.model, id);
    setState(() {
      fields.add(field);
    });
  }

  FieldModel createArrayItemFromModel(FieldModel model, String id) {
    if (model is TextFieldModel) {
      final List<PathItem> pathList = List.from(model.path.path);
      pathList[pathList.length - 1] = PathItem(id, model.fieldType);
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormBuilder(fields: fields, dependencies: const []),
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
  }
}