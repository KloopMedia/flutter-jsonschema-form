import 'models.dart';

class Dependency {
  final String parentId;
  final List<dynamic> values;
  final FieldModel? field;

  const Dependency({required this.parentId, required this.values, this.field});
}
