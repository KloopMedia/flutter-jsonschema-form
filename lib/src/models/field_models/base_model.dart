import '../../helpers/helpers.dart';
import '../models.dart';

abstract class BaseModel {
  final String id;
  final String? title;
  final String? description;
  final FieldType fieldType;
  final PathModel path;
  final DependencyModel? dependency;

  const BaseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fieldType,
    required this.path,
    required this.dependency,
  });

  BaseModel copyWith();

  String get fieldTitle => title ?? id;
}
