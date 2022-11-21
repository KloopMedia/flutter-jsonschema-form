import 'package:form_builder_file_picker/form_builder_file_picker.dart';

enum FileSource {
  web,
  local,
}

class FileModel {
  final FileSource source;
  final Uri? uri;
  final String name;
  final FileType type;

  const FileModel({required this.source, this.uri, required this.name, required this.type});
}