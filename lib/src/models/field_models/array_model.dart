import '../../helpers/helpers.dart';
import '../models.dart';

abstract class ArrayModel extends BaseModel {
  ArrayModel({
    required super.id,
    required super.path,
    required super.title,
    required super.description,
    required super.dependency,
  }) : super(fieldType: FieldType.array);

  factory ArrayModel.fromSchema({
    required String id,
    required PathModel path,
    required Map<String, dynamic> schema,
    required Map<String, dynamic>? uiSchema,
    required DependencyModel? dependency,
  }) {
    final items = schema['items'];
    final itemsUi = uiSchema?['items'] ?? [];
    final String? title = schema['title'];
    final String? description = schema['description'];

    List<BaseModel> createFixedArrayFields(List items, List itemsUi, PathModel path) {
      return items.mapWithIndex((item, index) {
        final field = item as Map<String, dynamic>;
        Map<String, dynamic> ui;
        try {
          ui = itemsUi[index];
        } on RangeError {
          ui = {};
        }
        return FormSerializer.createModelFromSchema(
          id: index.toString(),
          schema: field,
          uiSchema: ui,
          path: path,
          isRequired: true,
          dependency: null,
        );
      }).toList();
    }

    if (items is List) {
      final fields = createFixedArrayFields(items, itemsUi, path);

      return StaticArrayModel(
        id: id,
        items: fields,
        path: path,
        title: title,
        description: description,
        dependency: dependency,
      );
    } else if (items is Map<String, dynamic>) {
      final itemType = FormSerializer.createModelFromSchema(
        id: '',
        schema: items,
        uiSchema: uiSchema,
        path: path,
        isRequired: true,
        dependency: null,
      );
      return DynamicArrayModel(
        id: id,
        itemType: itemType,
        path: path,
        title: title,
        description: description,
        dependency: dependency,
      );
    } else {
      throw Exception('Failed to determine ArrayModel type for [$id]');
    }
  }
}

class StaticArrayModel extends ArrayModel {
  final List<BaseModel> items;

  StaticArrayModel({
    required super.id,
    required super.path,
    required super.title,
    required super.description,
    required super.dependency,
    required this.items,
  });

  @override
  BaseModel copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}

class DynamicArrayModel extends ArrayModel {
  final BaseModel itemType;

  DynamicArrayModel({
    required super.id,
    required super.path,
    required super.title,
    required super.description,
    required super.dependency,
    required this.itemType,
  });

  @override
  BaseModel copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}

extension on Iterable {
  Iterable<T> mapWithIndex<T, E>(T Function(E e, int i) toElement) sync* {
    int index = 0;
    for (var value in this) {
      yield toElement(value, index);
      index++;
    }
  }
}
