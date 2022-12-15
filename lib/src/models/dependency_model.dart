import 'models.dart';

class DependencyModel {
  final String parentId;
  final PathModel parentPath;
  final String id;
  final List<dynamic> values;
  final FieldModel? field;

  const DependencyModel({
    required this.id,
    required this.parentId,
    required this.values,
    this.field,
    required this.parentPath,
  });
}
