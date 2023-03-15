import 'widget_model.dart';

class TextAreaWidgetModel extends WidgetModel {
  final int rows;

  TextAreaWidgetModel(Map<String, dynamic>? options) : rows = getOption<int>(options, 'rows') ?? 4;
}