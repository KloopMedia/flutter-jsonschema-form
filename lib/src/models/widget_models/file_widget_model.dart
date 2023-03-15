import 'widget_model.dart';

class FileWidgetModel extends WidgetModel {
  final bool private;
  final bool multiple;

  FileWidgetModel(Map<String, dynamic>? options)
      : private = getOption<bool>(options, 'private') ?? false,
        multiple = getOption<bool>(options, 'multiple') ?? false;
}
