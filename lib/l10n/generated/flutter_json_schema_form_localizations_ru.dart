import 'flutter_json_schema_form_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class FlutterJsonSchemaFormLocalizationsRu extends FlutterJsonSchemaFormLocalizations {
  FlutterJsonSchemaFormLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get submit => 'Отправить';

  @override
  String get select_file_start => 'Выберите файл';

  @override
  String get select_file_end => ' для загрузки';

  @override
  String get file_upload_success => 'Файл успешно загружен';

  @override
  String get answer_correct => 'Правильно';

  @override
  String get answer_wrong => 'Неправильно';

  @override
  String get quiz_score => 'Процент правильных ответов:';
}
