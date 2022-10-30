import '../helpers/helpers.dart';

abstract class Field {
  String id;
  String? title;
  String? description;
  FieldType? fieldType;
  WidgetType? widgetType;
  Path path;

  Field({
    required this.id,
    this.title,
    this.description,
    this.fieldType,
    this.widgetType,
    required this.path,
  });

  String? get fieldTitle => title ?? id;

  set setId(String id) => this.id = id;
}

class Path {
  final List<PathItem> path;

  Path(this.path);

  void add(String id, FieldType? fieldType) => path.add(PathItem(id, fieldType));

  List<String> get stringPath => path.map((e) => e.toString()).toList();
}

class PathItem {
  String id;
  FieldType? fieldType;

  PathItem(this.id, this.fieldType);

  @override
  String toString() => '{id: $id, type: $fieldType}';
}
