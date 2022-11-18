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
    WidgetType? widgetType,
    this.itemType,
    required PathModel path,
  })  : isFixed = false,
        items = null,
        super.init(
            id: id,
            title: title,
            description: description,
            fieldType: FieldType.array,
            widgetType: widgetType,
            path: path,
            isRequired: false);

  ArrayModel.fixed({
    required String id,
    String? title,
    String? description,
    WidgetType? widgetType,
    required this.items,
    required PathModel path,
  })  : itemType = null,
        isFixed = true,
        super.init(
          id: id,
          title: title,
          description: description,
          fieldType: FieldType.array,
          widgetType: widgetType,
          path: path,
          isRequired: false,
        );
}
