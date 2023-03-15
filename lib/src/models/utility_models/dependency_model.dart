import '../models.dart';

class DependencyModel {
  final String parentId;
  final PathModel parentPath;
  final List<dynamic> values;

  const DependencyModel({
    required this.parentId,
    required this.parentPath,
    required this.values,
  });
}
