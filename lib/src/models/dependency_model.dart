import 'models.dart';

class Dependency {
  final String parentId;
  final PathModel parentPath;
  final List<dynamic> conditions;

  Dependency({
    required this.parentId,
    required this.parentPath,
    required this.conditions,
  });
}