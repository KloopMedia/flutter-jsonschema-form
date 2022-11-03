import 'models.dart';

class Dependency {
  final String parentId;
  final List<dynamic> values;
  final BaseField? field;

  const Dependency({required this.parentId, required this.values, this.field});
}
