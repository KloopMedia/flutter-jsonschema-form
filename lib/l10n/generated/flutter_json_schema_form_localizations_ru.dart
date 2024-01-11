import 'flutter_json_schema_form_localizations.dart';

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
  String get answer_correct => 'Правильно';

  @override
  String get answer_wrong => 'Неправильно';

  @override
  String get quiz_score => 'Процент правильных ответов:';
}
