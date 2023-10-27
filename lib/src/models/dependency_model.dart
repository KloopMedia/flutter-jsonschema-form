import 'models.dart';

class Dependency {
  final String parentId;
  final PathModel parentPath;
  final List<dynamic> conditions;
  final Dependency? parentDependency;

  Dependency({
    required this.parentId,
    required this.parentPath,
    required this.conditions,
    required this.parentDependency,
  });
}
