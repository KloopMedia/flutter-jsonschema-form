import 'dart:convert';

import '../helpers/helpers.dart';

class PathModel {
  final List<PathItem> path;

  const PathModel(this.path);

  const PathModel.empty() : path = const [];

  PathModel add(String id, FieldType? fieldType) {
    final newPath = List.of(path);
    newPath.add(PathItem(id, fieldType));
    return PathModel(newPath);
  }

  PathModel removeLast() {
    final newPath = List.of(path);
    newPath.removeLast();
    return PathModel(newPath);
  }

  List<String> get stringPath => path.map((e) => e.toString()).toList();

  @override
  String toString() => path.map((e) => e.id).join('.');

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
