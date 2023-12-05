import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

Future<String> getFileSize(Reference file) async {
  final metadata = await file.getMetadata();
  final bytes = metadata.size;
  if (bytes == null || bytes == 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB'];
  final i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
}

String? getMimeType(String name) {
  final mimeType = lookupMimeType(name);
  return mimeType?.split('/').first;
}
