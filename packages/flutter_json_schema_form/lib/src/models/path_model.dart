import 'dart:convert';

import '../helpers/helpers.dart';

class PathModel {
  final List<PathItem> path;

  const PathModel(this.path);

  void add(String id, FieldType? fieldType) => path.add(PathItem(id, fieldType));

  List<String> get stringPath => path.map((e) => e.toString()).toList();

  factory PathModel.fromString(String stringPath) {
    List<Map<String, dynamic>> parsedPath = json.decode(stringPath);
    List<PathItem> path = parsedPath
        .map((item) => PathItem(
              item['id'],
              decodeFieldType(item['type']),
            ))
        .toList();
    return PathModel(path);
  }
}

class PathItem {
  String id;
  FieldType? fieldType;

  PathItem(this.id, this.fieldType);

  @override
  String toString() => '{id: $id, type: $fieldType}';
}
