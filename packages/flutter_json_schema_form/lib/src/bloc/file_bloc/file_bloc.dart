import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_json_schema_form/src/models/file_model.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final Reference? storage;

  FileBloc({value, required this.storage}) : super(FilesInitial(files: _parseValue(value))) {
    on<AddFileEvent>(onAddFileEvent);
    on<RemoveFileEvent>(onRemoveFileEvent);
    on<ViewFileEvent>(onViewFileEvent);
  }

  static List<FileModel> _parseValue(value) {
    return [];
  }

  void onAddFileEvent(AddFileEvent event, Emitter<FileState> emit) async {
    final ref = storage;
    final name = event.name;
    final bytes = event.bytes;
    final type = event.type;

    // if (ref == null) {
    //   emit(
    //     FileError(
    //       error: Exception('FireBase Storage reference is null!'),
    //       files: state.files,
    //     ),
    //   );
    //   return;
    // }

    if (bytes != null) {
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );

      // final uploadTask = ref.putData(bytes, metadata);
      // emit.forEach(
      //   uploadTask.snapshotEvents,
      //   onData: (snapshot) {
      //     final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      //     final name = snapshot.ref.name;
      //     return FileLoading(files: state.files, name: name, progress: progress);
      //   },
      //   onError: (error, trace) {
      //     String errorMessage;
      //     if (error is FirebaseException && error.code == 'canceled') {
      //       errorMessage = 'Upload canceled.';
      //     } else {
      //       errorMessage = 'Something went wrong.';
      //     }
      //     return FileError(
      //       error: Exception(errorMessage),
      //       files: state.files,
      //     );
      //   },
      // );
      final updatedFiles = [...state.files, FileModel(source: FileSource.local, name: name, type: type)];
      emit(FilesModified(files: updatedFiles));
    }
  }

  void onRemoveFileEvent(RemoveFileEvent event, Emitter<FileState> emit) {}

  void onViewFileEvent(ViewFileEvent event, Emitter<FileState> emit) {}
}
