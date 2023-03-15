import '../models.dart';

class NumberFieldModel extends FieldModel<double> {
  NumberFieldModel.fromSchema({
    required super.id,
    required super.path,
    required super.schema,
    required super.uiSchema,
    required super.isRequired,
    required super.widget,
    required super.dependency,
  }) : super.fromSchema();

  @override
  copyWith({String? id, PathModel? path}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

// @override
// NumberFieldModel copyWith({String? id, PathModel? path}) {
//   return NumberFieldModel(
//     id: id ?? this.id,
//     path: path ?? this.path,
//   );
// }
}
