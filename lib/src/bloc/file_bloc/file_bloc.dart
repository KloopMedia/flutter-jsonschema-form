import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mime/mime.dart';
import 'package:video_compress/video_compress.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final Reference storage;
  final bool allowMultiple;
  final bool enabled;
  final void Function(String? value) onChanged;

  FileBloc({
    required dynamic value,
    required this.storage,
    required this.allowMultiple,
    required this.enabled,
    required this.onChanged,
  }) : super(FilesInitial(files: _decodeValue(storage, value), enabled: enabled)) {
    on<AddFileEvent>(onAddFileEvent);
    on<RemoveFileEvent>(onRemoveFileEvent);
    on<ViewFileEvent>(onViewFileEvent);
    on<CloseFileViewerEvent>(onCloseFileViewerEvent);
    on<UploadSuccessEvent>(onUploadSuccessEvent);
    on<UploadFailEvent>(onUploadFailEvent);
  }

  static List<Reference> _decodeValue(Reference storage, dynamic value) {
    Iterable<MapEntry<String, String>> entries;
    try {
      if (value is String) {
        final decodedValue = Map<String, String>.from(jsonDecode(value));
        entries = decodedValue.entries;
      } else if (value is Map) {
        entries = value.entries.cast();
      } else {
        entries = [];
      }
    } catch (_) {
      entries = [];
    }

    final files = entries.map((file) => storage.storage.ref(file.value)).toList();

    return files;
  }

  static String? _encodeValue(List<Reference> files) {
    if (files.isEmpty) {
      return null;
    }

    final Map<String, String> value = {};
    for (final file in files) {
      value[file.name] = file.fullPath;
    }

    final encodedValue = jsonEncode(value);
    return encodedValue;
  }

  String _handleFirebaseStorageExceptions(FirebaseException e) {
    if (e.code == 'object-not-found') {
      return 'The specified object was not found in the storage bucket.';
    } else if (e.code == 'unauthorized') {
      return 'The user is not authorized to access the object in the storage bucket.';
    } else if (e.code == 'canceled') {
      return 'The operation was canceled by the user or by another request.';
    } else {
      return 'An unknown error occurred in the storage service.';
    }
  }

  void onAddFileEvent(AddFileEvent event, Emitter<FileState> emit) async {
    final name = event.name;
    final bytes = event.bytes;
    final file = event.files.first;

    if (bytes != null) {
      emit(FileCompressing(files: state.files));

      final mime = lookupMimeType(name);
      final metadata = SettableMetadata(
        contentType: mime,
      );
      final type = mime?.split('/').first;
      final ref = storage.child(name);

      if (kIsWeb) {
        await uploadToStorage(ref, bytes, metadata, emit);
      } else {
        Uint8List? compressedFileBytes;
        if (type == "video") {
          compressedFileBytes = await compressVideo(file.path);
        } else if (type == "image") {
          compressedFileBytes = await FlutterImageCompress.compressWithList(bytes, quality: 70);
        } else {
          await uploadToStorage(ref, bytes, metadata, emit);
        }
        await uploadToStorage(ref, compressedFileBytes, metadata, emit);
      }
    }
  }

  Future<void> uploadToStorage(Reference ref, Uint8List? compressedFileBytes,
      SettableMetadata metadata, Emitter<FileState> emit) async {
    final uploadTask = ref.putData(compressedFileBytes!, metadata);
    emit(FileLoading(files: state.files, uploadTask: uploadTask));
    try {
      final snapshot = await uploadTask;
      add(UploadSuccessEvent(snapshot.ref));
    } on FirebaseException catch (e) {
      final errorMessage = _handleFirebaseStorageExceptions(e);
      emit(FileError(errorMessage: errorMessage, files: state.files));
    } catch (e) {
      emit(FileError(errorMessage: 'Other error', files: state.files));
    }
  }

  void onRemoveFileEvent(RemoveFileEvent event, Emitter<FileState> emit) {
    final files = List.of(state.files);
    files.removeAt(event.index);
    emit(FilesModified(files: files));
    final value = _encodeValue(files);
    onChanged(value);
  }

  void onViewFileEvent(ViewFileEvent event, Emitter<FileState> emit) {
    emit(FilePreview(files: state.files, file: event.file));
  }

  void onCloseFileViewerEvent(CloseFileViewerEvent event, Emitter<FileState> emit) {
    emit(FilesModified(files: state.files));
  }

  void onUploadSuccessEvent(UploadSuccessEvent event, Emitter<FileState> emit) {
    List<Reference> files;
    if (allowMultiple) {
      files = [event.file, ...state.files];
    } else {
      files = [event.file];
    }
    emit(FileUploadSuccess(files: files));
    emit(FilesModified(files: files));
    final value = _encodeValue(files);
    onChanged(value);
  }

  void onUploadFailEvent(UploadFailEvent event, Emitter<FileState> emit) {
    emit(FilesModified(files: state.files));
  }

  Future<Uint8List?> compressVideo(String path) async {
    final compressedVideoInfo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    final compressedVideoBytes = await compressedVideoInfo?.file?.readAsBytes();
    return compressedVideoBytes;
  }
}
