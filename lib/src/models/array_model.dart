import '../helpers/helpers.dart';
import 'models.dart';

class ArrayModel extends FieldModel {
  final bool isFixed;
  final List<FieldModel>? items;
  final FieldModel? itemType;

  @override
  void copyWith({String? id, PathModel? path}) {}

  ArrayModel.dynamic({
    required String id,
    String? title,
    String? description,
    this.itemType,
    required PathModel path,
  })  : isFixed = false,
        items = null,
        super.init(
          id: id,
          title: title,
          description: description,
          fieldType: FieldType.array,
          widgetType: const NullWidgetModel(),
          path: path,
          isRequired: false,
          disabled: false,
          readOnly: false,
        );

  ArrayModel.fixed({
    required String id,
    String? title,
    String? description,
    required this.items,
    required PathModel path,
  })  : itemType = null,
        isFixed = true,
        super.init(
          id: id,
          title: title,
          description: description,
          fieldType: FieldType.array,
          widgetType: const NullWidgetModel(),
          path: path,
          isRequired: false,
          disabled: false,
          readOnly: false,
        );
}
