import '../../helpers/helpers.dart';
import '../models.dart';

class TextFieldModel extends FieldModel<String> {
  final FormatType? format;

  TextFieldModel.fromSchema({
    required super.id,
    required super.path,
    required super.schema,
    required super.uiSchema,
    required super.isRequired,
    required super.widget,
    required super.dependency,
    required this.format,
  }) : super.fromSchema();

  @override
  copyWith({String? id, PathModel? path}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

// @override
// TextFieldModel copyWith({String? id, PathModel? path}) {
//   return TextFieldModel(
//     id: id ?? this.id,
//     widgetType: widgetType,
//     path: path ?? this.path,
//     isRequired: isRequired,
//     format: format,
//     fieldType: fieldType,
//     schema: schema,
//   );
// }
}
