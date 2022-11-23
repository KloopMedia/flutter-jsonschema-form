import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final Reference storage;

  FileBloc({
    required dynamic value,
    required this.storage,
  }) : super(FilesInitial(files: _parseValue(value))) {
    on<AddFileEvent>(onAddFileEvent);
    on<RemoveFileEvent>(onRemoveFileEvent);
    on<ViewFileEvent>(onViewFileEvent);
    on<UploadSuccessEvent>(onUploadSuccessEvent);
  }

  static List<Reference> _parseValue(dynamic value) {
    Iterable<MapEntry> entries;
    if (value is String) {
      final Map<String, dynamic> parsedData = json.decode(value);
      entries = parsedData.entries;
    } else if (value is Map) {
      entries = value.entries;
    } else {
      entries = [];
    }
    return [];
    // return entries
    //     .map((file) => FileModel(
    //           source: FileSource.web,
    //           name: file.key,
    //           type: FileType.media,
    //         ))
    //     .toList();
  }

  void onAddFileEvent(AddFileEvent event, Emitter<FileState> emit) async {
    final name = event.name;
    final bytes = event.bytes;

    if (bytes != null) {
      final mime = lookupMimeType(name);
      final ref = storage.child(name);

      final metadata = SettableMetadata(
        contentType: mime,
      );

      final uploadTask = ref.putData(bytes, metadata);

      emit(FileLoading(files: state.files, uploadTask: uploadTask));
    }
  }

  void onRemoveFileEvent(RemoveFileEvent event, Emitter<FileState> emit) {}

  void onViewFileEvent(ViewFileEvent event, Emitter<FileState> emit) {
    emit(FilePreview(files: state.files, file: event.file));
  }

  void onUploadSuccessEvent(UploadSuccessEvent event, Emitter<FileState> emit) {
    final files = [...state.files, event.file];
    emit(FilesModified(files: files));
  }
}
