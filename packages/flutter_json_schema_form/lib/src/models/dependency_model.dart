import 'models.dart';

class DependencyModel {
  final String parentId;
  final List<dynamic> values;
  final FieldModel? field;

  const DependencyModel({required this.parentId, required this.values, this.field});
}
